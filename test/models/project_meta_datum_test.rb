require 'test_helper'

class ProjectMetaDatumTest <  BaseModelTest
  def new
    return ProjectMetaDatum.new
  end

  test "project expected to be set" do
    instance = new
    has_key(instance, :project)
    instance.project = Project.first
    not_has_key instance, :project
  end

  test "quantifier expected to be set" do
    instance = new
    has_key(instance, :quantifier)
    t = Quantifier.first
    instance.quantifier = t
    not_has_key instance, :quantifier
  end
end
