class Role < BaseModel
  has_many :user_roles

  def readonly?
    true
  end
end
