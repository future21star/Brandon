class ProjectSummary < BaseModel
  geocoded_by :project

  scope :in_range, ->(latlng, page=1) {near(latlng, 10, :order_by => :distance).paginate(:page => page)}
  # Use raw SQL for join to bypass a join to the project table. We can go right from summary->project_tags
  scope :by_tag, ->(tag) {joins('INNER JOIN project_tags on project_summaries.project_id = project_tags.project_id')
                              .where(:project_tags => {:tag => tag})}

  validates_presence_of :project, :latitude, :longitude, :title, :picture_url

  belongs_to :project
  belongs_to :picture
  has_many :project_tags
end
