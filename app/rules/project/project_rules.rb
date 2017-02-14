class ProjectRules
  attr_reader :access_rules, :state_rules

  def initialize(project, user)
    @access_rules = ProjectAccessRules.new(project, user)
    @state_rules = ProjectStateRules.new(project)
  end
end