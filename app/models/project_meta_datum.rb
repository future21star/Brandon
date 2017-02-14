class ProjectMetaDatum < BaseModel
  has_paper_trail

  validates_presence_of :project, :quantifier

  belongs_to :project
  belongs_to :quantifier
end
