require 'test_helper'


class QuoteTest < BaseModelTest
  def new
    return Quote.new
  end

  test "business expected to be set" do
    instance = new
    has_key(instance, :business)
    instance.business = Business.new
    not_has_key instance, :business
  end

  test "projects expected to be set" do
    instance = new
    has_key(instance, :project)
    instance.project = create_cooked_project
    instance.project.publish
    not_has_key instance, :project
  end

  test "When submitting a quote, the bid MUST be in the proper state" do
    instance = create_cooked_quote
    Bid.update_all :available => false
    has_key(instance, :bid)
    bid = Bid.find_by_user_id instance.business.user
    bid.available = true
    save bid
    not_has_key(instance, :bid)
  end

  test "Trying to quote a project in the wrong state, should be an error" do
    project = create_cooked_project
    project.save!
    instance = new
    instance.project = project
    has_key(instance, :project)

    project.publish!
    not_has_key(instance, :bid)

    project.close!
    has_key(instance, :project)

    project.accept!
    has_key(instance, :project)

    project = create_cooked_project
    project.save!
    has_key(instance, :project)

    project.cancel!
    has_key(instance, :project)
  end

  test "When submitting a quote, data structure should be created" do
    Quote.transaction do
      quote = create_cooked_quote
      summary = "This is am estimates summary"
      description = "test description that needs to be so long that it doesn't trigger the other validations"
      estimate1 = Estimate.new(:summary => summary + "1", :description => description + "1", :price => 1.21,
                                  :duration => 11.5, :quantifier => Quantifier.first)
      estimate2 = Estimate.new(:summary => summary + "2", :description => description + "2", :price => 2.12,
                                  :duration => 22.5, :quantifier => Quantifier.first)
      quote.estimates.clear
      quote.estimates << estimate1
      quote.estimates << estimate2

      used_bid_count = Bid.my_available(quote.business.user).count
      save(quote)

      assert_equal true, quote.errors.empty?
      assert quote.id
      assert quote.bid.id
      assert_equal false, quote.bid.available
      assert_not_nil quote.bid.consumed_at
      post_save_used_bid_count = Bid.my_available(quote.business.user).count
      assert_equal used_bid_count-1, post_save_used_bid_count
      assert quote.estimates
      assert quote.estimates[0].id
      assert_equal  estimate1.summary, quote.estimates[0].summary
      assert_equal  estimate1.description, quote.estimates[0].description
      assert_equal  estimate1.price, quote.estimates[0].price
      assert_equal  estimate1.duration, quote.estimates[0].duration
      assert_equal  estimate1.quantifier, quote.estimates[0].quantifier

      assert quote.estimates[1].id
      assert_equal  estimate2.summary, quote.estimates[1].summary
      assert_equal  estimate2.description, quote.estimates[1].description
      assert_equal  estimate2.price, quote.estimates[1].price
      assert_equal  estimate2.duration, quote.estimates[1].duration
      assert_equal  estimate2.quantifier, quote.estimates[1].quantifier
    end
  end

  test "should only be able to see my quotes" do
    mine = create_cooked_quote
    save mine

    theirs = create_cooked_quote
    save theirs

    quotes = Quote.mine(mine.business.user)
    assert quotes
    assert !quotes.empty?
    assert_equal mine.id, quotes[0].id
  end

  test "When regular user, my_quotes should not throw error, just reutrn empty" do
    user = create_cooked_user
    save user

    quotes = Quote.mine(user)
    assert quotes
    assert quotes.empty?
  end

  test "When two quotes attempt to use the same bid, optimistic locking should detect this" do
    # This test is extremely sensitive and has a tendancy to fail from the command line but pass here
    quote = save_all_pieces_of_quote_but_not_quote(false)
    user = quote.business.user

    # Due to order of operations, we know that a validation error will cause a bid to be set, and return.
    # We will exploit this to test that bid locking is working properly
    save quote

    assert !quote.errors.empty?
    assert_not_nil quote.bid
    assert !quote.bid.available

    quote2 = create_cooked_quote(user)
    save quote2

    assert_raise(ActiveRecord::StaleObjectError) {
      quote.project.publish!
      assert_nil quote.id
      save quote
    }
  end

  test "summary scope should return only the latest" do
    expected = 5
    user = User.first
    bus_user = create_cooked_business_user
    save bus_user
    (expected+1).times.each{
      project = create_cooked_project(user)
      save project
      save create_cooked_quote(bus_user, project)
    }

    results = Quote.summary(bus_user)
    assert_not_nil results
    assert_same expected, results.length
  end
end
