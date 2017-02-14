class UserRole < BaseModel
  after_initialize :set_default_role, :if => :new_record?

  validates_presence_of :user, :role

  belongs_to :user
  belongs_to :role

  def set_default_role
    unless role
      self.role_id ||= ROLE_USER
    end
  end
end
