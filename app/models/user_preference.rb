class UserPreference < BaseModel

  validates_presence_of :user
  validates_presence_of :preference

  belongs_to :user
  belongs_to :preference
end
