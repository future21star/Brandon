class LocationDTO < BaseDTO

  def self.instance_to_hash(obj)
    return {
        :id => obj.id,
        :latitude => obj.latitude,
        :longitude => obj.longitude,
        :visible => obj.visible,
        :name => obj.name ? obj.name : '',
    }
  end
end