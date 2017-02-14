require 'test_helper'

module Projects
  class ProjectMachineTest < BaseModelTest

    def new
      instance = get
      assert_equal true, instance.draft?
      return instance
    end

    def get
     Project.first
    end

    test "happy path with acceptance of bid" do
      machine = new
      machine.publish!

      assert machine.published?
      assert machine.published_at
      machine.close!
      assert machine.closed?
      machine.accept!
      assert machine.accepted?

      hard_check = get
      assert hard_check.accepted?
    end

    test "draft can only transition to publish or cancel" do
      machine = get
      assert machine.draft?

      assert machine.may_publish?
      assert machine.may_cancel?
      assert !machine.may_accept?
      assert !machine.may_close?
    end

    test "published must set published_date" do
      machine = create_cooked_project
      save machine
      machine.publish
      save machine
      project = Project.find_by_id machine.id
      assert project
      assert project.published?
      assert project.published_at
    end

    test "published can only transition to closed or cancel" do
      machine = get
      unless machine.published?
        machine.publish
      end
      assert machine.published?

      assert machine.may_close?
      assert machine.may_cancel?
      assert !machine.may_publish?
      assert !machine.may_accept?
    end

    test "closed can only transition to accepted" do
      machine = get
      unless machine.closed?
        machine.publish
        machine.close
      end
      assert machine.closed?

      assert machine.may_accept?
      assert !machine.may_close?
      assert !machine.may_cancel?
      assert !machine.may_publish?
    end

    test "cancelled can not transition to anything" do
      machine = get
      unless machine.cancelled?
        machine.cancel
      end
      assert machine.cancelled?

      assert !machine.may_accept?
      assert !machine.may_close?
      assert !machine.may_cancel?
      assert !machine.may_publish?
    end

  end
end
