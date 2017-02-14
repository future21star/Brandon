class UserDTO < BaseDTO

  def self.instance_to_hash(obj)
    return {
        :id => obj.id,
        :first_name => obj.first_name,
        :last_name => obj.last_name,
        :full_name => obj.full_name,
        :email => obj.email,
        # FIXME: Properly hook this up once we have the ability to upload profile pictures
        :picture => ActionController::Base.helpers.image_path('profile-pic.jpg')
    }
  end
end