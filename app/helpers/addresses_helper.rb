module AddressesHelper

  def self.get_country_list
    return Country.where('name in (?)', SUPPORTED_COUNTRIES).to_a
  end

  def self.get_province_list(country)
    return country.provinces
  end
end
