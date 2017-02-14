class PreferencesDTO < BaseDTO

  def self.instance_to_hash(obj)
    name = obj.preference.name
    return {
     :id => obj.id,
     :name => name,
     :email => obj.email,
     :internal => obj.internal,
    }
  end
end