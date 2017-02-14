class ProjectStateRules
  attr_reader :may_publish, :may_close, :may_accept, :may_cancel, :is_published

  def initialize(project)
    @may_publish = project.may_publish?
    @may_close = project.may_close?
    @may_accept = project.may_accept?
    @may_cancel = project.may_cancel?
    @is_published = project.published?
  end
end