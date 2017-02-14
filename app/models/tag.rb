class Tag < BaseModel
  has_paper_trail

  scope :like, ->(name) {where("#{:name} LIKE ?", '%' + name + '%')}
  scope :all_alpha, -> {all.order(:name)}

  before_validation :clean_input!

  validates :name, uniqueness: {case_sensitive: false}
  validates_length_of :name, :maximum => 50

  has_many :business_tag
  has_many :project_tag

  def clean_input!
    if self.name
      self.name = name.downcase.strip
    end
  end

  def readonly?
    true
  end
end
