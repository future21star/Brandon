class Address < BaseModel
  has_paper_trail

  before_validation :clean_input!

  validates_presence_of :postal_code, :street_name, :house_number, :province, :city
  validates_length_of :postal_code, :minimum => 5, :maximum => 6
  validates_length_of :house_number, :maximum => 10
  validates_length_of :apartment, :maximum => 15
  validates_length_of :street_name, :maximum => 255
  validates_length_of :city, :maximum => 255

  belongs_to :province
  has_one :location, :autosave => true
  has_one :user

  def clean_input!
    self.postal_code = LocationHelper.clean_postal_code self.postal_code
  end

  def country_alpha2
    return (province != nil && province.country != nil) ? province.country.alpha2 : nil
  end

  def full_address
    apartment = self.apartment ? self.apartment : nil
    number = self.house_number
    if apartment
      number += '-' + apartment
    end

    return number + ' ' + self.street_name + ', ' + self.city + ', ' + self.province.code
  end
end
