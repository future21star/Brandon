class Province < BaseModel
  belongs_to :country

  def readonly?
    true
  end
end
