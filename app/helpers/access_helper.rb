module AccessHelper

  def self.user_has_role(role, user)
    if user
      if user.has_role(role)
        return true
      end
    end
    return false
  end
end
