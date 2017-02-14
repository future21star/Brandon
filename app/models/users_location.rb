class UsersLocation < BaseModel

  validates_presence_of :user, :location

  belongs_to :user
  belongs_to :location
end
