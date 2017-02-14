class UserAcceptanceOfTerms < BaseModel

  validates_presence_of :user, :terms_and_conditions

  belongs_to :user
  belongs_to :terms_and_conditions

  def self.has_user_accepted?(user)
    UserAcceptanceOfTerms.where(:user => user,:terms_and_conditions => TermsAndConditions.latest).count > 0
  end
end
