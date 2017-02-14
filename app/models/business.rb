class Business < BaseModel
  has_paper_trail

  before_validation :clean_input!
  validates_associated :business_tags
  validates :company_name, presence: true
  validates_length_of :company_name, minimum: 2, :maximum => 255
  validates :phone_number, phone: true
  validates_length_of :phone_number, :minimum => 10, :maximum => 15
  validates_format_of :website, :with => /((http|https):\/\/)*[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :multiline => true, :unless => 'website.blank?'
  validates :website, url: true, :unless => 'website.blank?'
  validates_length_of :website, :maximum => 255, :unless => 'website.blank?'
  validates_presence_of :business_tags, :user
  before_create :create_role, :create_preferences

  attr_accessor :opt_in

  belongs_to :user, autosave: true
  has_many :business_tags, inverse_of: :business
  has_many :tags, through: :business_tags
  has_many :quotes, inverse_of: :business

  def clean_input!
    if self.phone_number
      phone_cleaned = self.phone_number.gsub(/\D/, '').strip
      if phone_cleaned.length < 11 && phone_cleaned[0] != '1'
        phone_cleaned = '1' + phone_cleaned
      end
      self.phone_number = phone_cleaned
    end
    if self.website && !self.website.strip.empty?
      altered_website = self.website.downcase
      unless altered_website.start_with?("http://") or altered_website.start_with?("https://")
        altered_website = "http://" + altered_website
      end
      self.website = altered_website
    end
  end

  def self.search(company_name, phone_number, website, page=1)
    # website is an optional field and as such we need special behaviour depending on what is passed in
    website_clause = "(website like ? OR website IS NULL)"
    # IF anything is passed into the website field, we must include it as a like clause, otherwise it should be a like or IS NULL
    unless website.blank?
      website_clause = "website like ?"
    end
    return Business.where("company_name like ? and phone_number like ? and #{website_clause}",
                   "%#{company_name}%", "%#{phone_number}%", "%#{website}%")
                  .paginate(:page => page)
  end


  private
    def create_role
      if  user.user_roles.where(:role_id => ROLE_BUSINESS).count == 0
        business_role = UserRole.new(:user => user, :role_id => ROLE_BUSINESS)
        user.user_roles << business_role
      end
    end

    def create_preferences
      self.opt_in ||= false
      Preference::BUSINESS_PREFERENCES.each { |name|
        preference = Preference.find_by_name!(name)
        self.user.user_preferences << UserPreference.new(
            :preference => preference, :email => self.opt_in, :internal => true )
      }
    end
end
