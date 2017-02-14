class Country < BaseModel

  has_many :provinces

  def readonly?
    true
  end
end
