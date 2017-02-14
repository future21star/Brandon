class Picture < BaseModel
  has_attached_file :a,
                    :styles => {:thumb => "256x256#" },
                    :convert_options => {:thumb => "-quality 75 -strip" }

  scope :mine, ->(user) {where(:user => user)}

  validates_presence_of :generated_name, :user
  validates :a, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :a
  validates_with AttachmentSizeValidator, attributes: :a, less_than: 3.megabytes
  validates_attachment_content_type :a, content_type: /\Aimage\/.*\Z/
  before_destroy :delete_validation

  belongs_to :user
  has_many :project_pictures

  def check_file_size
    valid?
    errors[:a_file_size].blank?
  end

  def delete_validation
    unless project_pictures.empty?
      errors.add :project_pictures, "Cannot delete a picture that is in use"
      return false
    end
  end
end
