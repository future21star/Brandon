
class Project < BaseModel
  include AASM
  include MyLogger
  has_paper_trail :ignore => [:published_at]

  # weird bug where the order was not by the id so forcing it.
  scope :mine, ->(user, page=1) {where(:user => user).order(:id).paginate(page: page)}
  scope :summary, ->(user) {mine(user).limit(5)}

  validates_presence_of :title, :summary, :description, :project_tags, :project_pictures, :user, :location, :measurement_groups
  validates_length_of :summary, minimum: 5, maximum: 250
  validates_length_of :title, minimum: 5, maximum: 100
  validates_length_of :description, minimum: 100
  validates_associated :project_meta_datum
  validates_associated :project_tags
  validates_associated :project_pictures
  validates_associated :measurement_groups
  validate :ensure_has_default

  belongs_to :user
  belongs_to :location
  has_one :project_summary
  has_one :project_meta_datum, inverse_of: :project
  has_many :project_tags, inverse_of: :project
  has_many :tags, through: :project_tags
  has_many :quotes
  has_many :project_pictures, inverse_of: :project
  has_many :pictures, through: :project_pictures
  has_many :measurement_groups

  enum state: {
    draft: 1,
    published: 2,
    closed: 3,
    accepted: 4,
    cancelled: 5
  }

  aasm :column => :state, :enum => true do
    state :draft, :initialize_find_by_cache => true
    state :published,:closed, :accepted, :cancelled

    after_all_transitions :log_change

    event :publish do
      transitions :from => :draft, :to => :published, :guard => :draft?
      after do
        update_attribute :published_at, DateTime.now
        summary = ProjectSummary.create(:latitude => location.latitude, :longitude => location.longitude,
                              :project => self, :title => self.title, :picture => default_picture,
                                        :picture_url => default_picture.a.url(:thumb))
        self.project_summary = summary
        CloseProjectJob.enqueue(self.id)
      end
    end

    event :close do
      transitions :from => :published, :to =>:closed, :guard => :published?
      after do
        self.project_summary.delete
      end
    end

    event :accept do
      transitions :from =>:closed, :to => :accepted, :guard => :closed?
    end

    event :cancel do
      transitions :from => [:draft, :published], :to => :cancelled do
       guard do
         draft? or published?
       end
      end
      after do
        if project_summary
          project_summary.delete
        end
      end
    end
  end

  def default_picture
    return project_pictures.default_picture(self).picture
  end

  private
    def log_change
      logger.info "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    end

    def ensure_has_default
      if project_pictures && !project_pictures.empty?
        default_set = false
        project_pictures.each { |pic|
          default_set ||= pic.default?
        }
        unless default_set
          project_pictures[0].default = true
        end
      end
    end
end
