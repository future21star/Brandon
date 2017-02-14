class BaseModel < ActiveRecord::Base
  self.abstract_class = true
  strip_attributes

  before_create :set_timestamps!
  before_update :set_updated!

  def set_timestamps!
    if self.attributes.include? :created_at
      @created_at = Time.now.utc
      set_updated!
    end
  end

  def set_updated!
    if self.attributes.include? :updated_at
      @updated_at = Time.now.utc
    end
  end

  def attributes
    super .symbolize_keys
  end
end
