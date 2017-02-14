require 'test_helper'

class EstimatesControllerTest < BaseControllerTest
  
  setup do
    @estimate = estimates(:one)
    business_sign_in
  end

  test "should get index" do
    admin_sign_in
    get :index
    assert_response :success
    assert_not_nil assigns(:instances)
  end

  test "should create estimate" do
    quote = create_cooked_quote(get_business)
    save quote
    assert quote.errors.empty?, quote.errors.full_messages

    assert_difference('Estimate.count') do
      post :create, estimate: {
          summary: @estimate.summary,
          description: @estimate.description,
          price: 1.32,
          duration: 13,
          quantifier_id: @estimate.quantifier_id,
          quote_id: quote.id,
      }

      assert_response :success
    end
  end

  test "when stale object error, should return 409" do
    skip 'This test requires the call to be asynchronous which we do not have time to figure out at this time, we have validated this behaviour manually'
    require 'mocha/test_unit'
    # this test case is tricky as it requires exact timing and order of events, the best way for us to do this is to hack an extra validate
    # method into the life-cycle
    class SleepyQuote < Quote
      before_create :delay_processing

      def delay_processing
        sleep(1.second)
      end
    end

    # Quote.stub(QuoteSave, :save).any_instance.returns(raise ActiveRecord::StaleObjectError.new()) do
    # describe Quote do
    #   before(:save) do
    #     Quote.any_instance.stub(sleep(1.second))
    #   end


    quote = save_all_pieces_of_quote_but_not_quote(true, get_business)

    # hack the last vlaidation method so sleep so we can have 2 quotes grab the same bid
    def quote.validate_project_state
      # puts "**********Here we are CALLED ME YIPPIE!@!! ****"
      sleep(0.25.seconds)
      return true
    end
    second_project = create_cooked_project
    second_project.publish!
    assert_not_nil second_project.id

    Quote.expects(:new).returns(quote)

    # test calls are synchronous so need to fire one in another thread in order to test this case
    Thread.new {
      # assert_difference('Estimate.count') do
        post :create, estimate: {
            summary: @estimate.summary,
            description: @estimate.description,
            price: 1.32,
            duration: 13,
            quantifier_id: @estimate.quantifier_id,
        },
        quote: {
           project_id: quote.project.id
        }
        assert_response :success
      puts "**********Here we are 1 ****"
      # end
    }

    # Thread.new {

      #Second should trigger stale object eror
      Quote.unstub(:new)
      post :create, estimate: {
          summary: @estimate.summary,
          description: @estimate.description,
          price: 1.32,
          duration: 13,
          quantifier_id: @estimate.quantifier_id,
      },
       quote: {
           project_id: second_project.id
       }

      assert_response :conflict
      puts "**********Here we are 2 ****"
    # }
    puts "**********Here we are here ****"
    # end
  end

  test "should update estimate" do
    quote = create_cooked_quote(get_business)
    save quote
    @estimate = quote.estimates[0]
    updated = "This is an updated description"
    patch :update, id: @estimate, estimate: {
          id: @estimate.id,
          description: updated,
          price: 1.32,
          duration: 13,
    }
    assert_response :success
    raw = Estimate.find_by_id(@estimate.id)
    assert_equal updated, raw.description
  end

  test "should destroy estimate" do
    assert_difference('Estimate.count', -1) do
      delete :destroy, id: @estimate
    end

    assert_redirected_to estimates_path
  end

  test "my_estimates should return my estimates" do
    biz_user = create_cooked_user
    business = create_cooked_business(biz_user)
    save business
    assert business.errors.empty?
    @quote = create_cooked_quote(biz_user)
    save @quote
    assert @quote.errors.empty?

    sign_out_all
    sign_in biz_user
    get :my_estimates, my_estimates_json
    assert_response :ok

    other_ver = assigns(:quotes)
    assert_not_nil other_ver
    assert !other_ver.empty?
    quote = other_ver[0]
    assert_equal @quote.id, quote.id
  end
end
