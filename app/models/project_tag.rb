class ProjectTag < BaseModel
  has_paper_trail

  validates :tag, presence: true
  validates_associated :tag

  belongs_to :project
  belongs_to :tag
end
