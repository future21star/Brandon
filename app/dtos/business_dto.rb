class BusinessDTO < BaseDTO

  def self.instance_to_hash(obj)
    tags = []
    obj.tags.each { |tag| tags << SimpleDTO.instance_to_hash(tag) }
    return {
        :id => obj.id,
        :company_name => obj.company_name,
        :phone_number => obj.phone_number,
        :biography => obj.biography,
        :website => obj.website,
        :tags => tags,
    }
  end
end