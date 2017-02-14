class AddressDTO < BaseDTO

  def self.instance_to_hash(obj)
    return {
        :id => obj.id,
        :house_number => obj.house_number,
        :street_name => obj.street_name,
        :postal_code => obj.postal_code,
        :apartment => obj.apartment,
        :city => obj.city,
        :province => obj.province_id,
        :country => obj.province.country.id,
    }
  end
end