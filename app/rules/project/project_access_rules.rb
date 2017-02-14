class ProjectAccessRules
  attr_reader :is_project_owner, :is_business_user, :can_quote, :can_report

  def initialize(project, user)
    @is_project_owner = user != nil && project.user.id === user.id
    @is_business_user = user ? user.has_role(ROLE_BUSINESS) : false
    @can_quote = @is_business_user && !@is_project_owner
    @can_report = user && project.published? && !@is_project_owner
  end
end