class TermsAndConditions < BaseModel

  def readonly?
    true
  end

  def self.latest
    return TermsAndConditions.where(:inactivated_at => nil).first
  end
end
