class Location < BaseModel
  geocoded_by :address

  scope :mine, ->(user) {joins(:users_locations).where(users_locations: {:user => user})}
  scope :have_names, ->{where.not({name: nil})}
  scope :only_visible, ->{where({visible: true})}

  validates_presence_of  :latitude, :longitude
  validates_numericality_of :latitude, :longitude
  validates_length_of :name, :maximum => 255, :unless => 'name.blank?'

  belongs_to :address
  has_many :users_locations

  attr_accessor :location_type

  def in_range page
    result = self.nearbys(10, :order_by =>:distance).paginate(:page => page)
    return result
  end
end
