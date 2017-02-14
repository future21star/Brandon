class User < BaseModel
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_paper_trail :ignore => [:updated_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at,
                              :last_sign_in_ip, :failed_attempts, :remember_created_at]

  scope :search, ->(first_name, last_name, email, page=1) { User.where("first_name like ? and last_name like ? and email like ?",
                                     "%#{first_name}%", "%#{last_name}%", "%#{email}%")
                              .paginate(:page => page)}

  before_validation :clean_input!

  validates :email, uniqueness: {case_sensitive: false}, email: true
  validates_length_of :email, minimum: 5, :maximum => 255
  validates_presence_of :address, :first_name, :last_name
  validates_length_of :first_name, :last_name, minimum: 1, :maximum => 255
  validates_associated :business, if: :business
  before_create :create_defaults

  after_create :post_creation

  attr_accessor :opt_in

  has_many :bid, inverse_of: :user
  has_many :projects, inverse_of: :user
  has_many :purchase, inverse_of: :user
  has_many :promo_code_associations, inverse_of: :user
  has_many :user_roles, inverse_of: :user
  has_many :users_locations, inverse_of: :user
  has_many :locations, through: :users_locations
  has_many :pictures
  has_many :user_preferences

  belongs_to :address, autosave: true
  has_one :business, autosave: true

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def full_name
    [first_name, last_name].join(' ')
  end
  def clean_input!
    if self.email
      self.email = email.downcase.strip
    end
  end

  def is_admin?
    has_role(ROLE_ADMIN)
  end

  def is_business?
    has_role(ROLE_BUSINESS)
  end

  def is_user?
    has_role(ROLE_USER)
  end

  def has_role(role)
    has_role = false
    if user_roles
      has_role = user_roles.select{|user_role|
        user_role.role_id == role
      }.count == 1
    end
    return has_role
  end

  def post_creation
    self.users_locations  << UsersLocation.new(:user => self, :location => self.address.location)
    self.users_locations.create
  end

  private
    def create_defaults
      if user_roles.where(:role_id => ROLE_USER).count == 0
        user_role = UserRole.new(:user => self, :role_id => ROLE_USER)
        self.user_roles << user_role
      end

      if self.user_preferences.empty?
        self.opt_in ||= false
        Preference::USER_PREFERENCES.each { |name|
          preference = Preference.find_by_name!(name)
          self.user_preferences << UserPreference.new(
              :preference => preference, :email => self.opt_in, :internal => true )
        }
      end
    end
end
