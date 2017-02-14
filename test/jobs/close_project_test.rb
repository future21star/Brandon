require 'test_helper'

class CloseProjectTest < BaseModelTest

  def new
    return CloseProjectJob.new
  end

  def params(id=Project.first.id)
    return [{"project_id" => id}]
  end

  test "project_id is required to create job" do
    test_cases = [nil, {}]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        CloseProjectJob.enqueue test_case
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {project_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "project_id is required on perform" do
    test_cases = [[{}]]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        CloseProjectJob.perform test_case
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {project_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "finding a project is required on perform" do
      exception = assert_raise(ActiveRecord::RecordNotFound) {
        CloseProjectJob.perform params(-1)
    }
  end

  test "Project must be in published state" do
    exception = assert_raise(ArgumentError) {
      CloseProjectJob.perform params
    assert exception
    assert exception.message.downcase.include?("not in the published state")
    }
  end

  test "Project must have its published at set" do
    exception = assert_raise(ArgumentError) {
      CloseProjectJob.perform params
    assert exception
    assert exception.message.downcase.include?("not in the published state")
    }
  end

  test "enqueuing jobs should succeed" do
    Resque.instance_eval do
      def enqueue(klass, *args)
        return true
      end
    end
    assert CloseProjectJob.enqueue(1)
  end

  test "Happy path should finish and set close" do
    project = Project.first
    project.publish!

    assert CloseProjectJob.perform params

    result = Project.first
    assert result
    assert result.closed?
  end

  test "If a project is queued, then cancelled, should not throw exceptions" do
    project = Project.first
    project.publish!
    project.cancel!

    assert CloseProjectJob.perform params

    result = Project.first
    assert result
    assert result.cancelled?
  end
end
