class BusinessTag < BaseModel
  has_paper_trail

  validates_presence_of :business, :tag
  validates_associated :tag

  belongs_to :business
  belongs_to :tag
end
