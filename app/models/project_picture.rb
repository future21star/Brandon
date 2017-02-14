class ProjectPicture < BaseModel
  has_paper_trail

  scope :default_picture, ->(project) {where(:project => project, :default => true).first}

  validates_presence_of :picture
  validates_associated :picture
  before_save :change_default, :if => :default


  belongs_to :project
  belongs_to :picture, autosave: true

  def change_default
    if project && !project.project_pictures.empty?
      project.project_pictures.each { |project_picture|
        if project_picture == self
          if project.project_summary
            project.project_summary.picture = project_picture.picture
            project.project_summary.save
          end
        else
          project_picture.default = false
          if project_picture.persisted?
            project_picture.save
          end
        end
      }
    end
  end
end
