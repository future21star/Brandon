require 'test_helper'

class FeedbackTest <  BaseModelTest
  def new
    return Feedback.new
  end

  test "name expected to be set" do
    instance = new
    has_key(instance, :name)
    instance.name = '301'
    not_has_key instance, :name
  end

  test "email expected to be set" do
    instance = new
    has_key(instance, :email)
    instance.email = 'email@email.com'
    not_has_key instance, :email
  end

  test "content expected to be set" do
    instance = new
    has_key(instance, :content)
    instance.content = 'content'
    not_has_key instance, :content
  end

  test "invalid email formats should be invalid" do
    instance = new
    emails = ["t", "t.", "t.t.com", "t@t", "t@.com", "t@.com", "@t.com"]
    emails.each { |email|
      instance.email = email
      has_key instance, :email
    }
  end

  test "valid email formats should be valid" do
    instance = new
    emails = ["t@t.com", "32brandon@t.com", "bra2d@t.com", "brandon.bd@t.com"]
    emails.each { |email|
      instance.email = email
      not_has_key instance, :email
    }
  end

  test "happy path should persist structure" do
    instance = create_cooked_feedback
    save instance

    assert instance.id
  end
end