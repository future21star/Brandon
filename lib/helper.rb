
module Helper

  def getRandomUnit
    Quantifier.by_category(QUANTIFIER_CATEGORY_DISTANCE).sample()
  end

  def getRandomClassification
    Quantifier.by_category(QUANTIFIER_CATEGORY_MEASUREMENT).sample()
  end

  def generateRandomString(max=26)
    return ('a'..'z').to_a.shuffle[0,max].join
  end

  def getRandomWebsite
    domain=generateRandomString
    suffix = generateRandomString(5)
    return "http://#{domain}.#{suffix}"
  end

  def create_cooked_user(opt_in=false)
    user = User.new :email => SecureRandom.uuid + "@test.com", :password => "testuser", :first_name => "Cookie",
                    :last_name => "Monster", :opt_in => opt_in, :confirmed_at => Time.now
    address =  create_cooked_address

    user.address = address
    return user
  end

  def create_cooked_business(user=create_cooked_user, website=getRandomWebsite, opt_in=false)
    business = Business.new(:company_name =>  SecureRandom.uuid, :phone_number => "519" + rand.to_s[2..8], :user => user,
      :website => website, :biography => SecureRandom.urlsafe_base64(100), :opt_in => opt_in)
    tag1 = BusinessTag.new(:business => business, :tag => Tag.first)

    business.business_tags << tag1

    return business
  end

  def create_cooked_business_user
    business = create_cooked_business

    business.user.user_roles << UserRole.new(:role_id => ROLE_BUSINESS)

    return business.user
  end

  def create_cooked_picture(user=create_cooked_user)
    picture = Picture.new(:user => user, :generated_name => SecureRandom.urlsafe_base64,
                          :a => File.open(Rails.root.join('test', 'tiger.jpg')))

    return picture
  end

  def create_cooked_project (user=create_cooked_user, location=create_cooked_location)
    title = "We ar ethe greatest title ever"
    summary = "This is a projects usmmary"
    description = "test description that needs to be so long that it doesn't trigger " \
        "the other validations. If you want a great result, write a great description"
    project = Project.new(:title => title, :summary => summary, :description => description, :user => user)
    tag1 = ProjectTag.new(:project => project, :tag => Tag.first)
    tag2 = ProjectTag.new(:project => project, :tag => Tag.last)
    project_meta = ProjectMetaDatum.new(:project => project, :start_date => DateTime.now,
                                        :quantifier => Quantifier.first)
    project_picture = ProjectPicture.new :picture => create_cooked_picture(user), :default => true
    measurement_group = create_width_length_measurements

    location.users_locations << create_cooked_user_location(user)

    project.project_meta_datum = project_meta
    project.project_tags << tag1
    project.project_tags << tag2
    project.project_pictures << project_picture
    project.measurement_groups << measurement_group
    project.location = location
    return project
  end

  def create_width_length_measurements(width=321.2, length=432.1)
    group = create_cooked_measurement_group(nil, nil)
    group.measurements << create_cooked_measurement(group, width)
    group.measurements << create_cooked_measurement(group, length)

    return group
  end

  @@order = 0
  def create_cooked_measurement_group(project=nil, measurement=create_cooked_measurement(nil))
    measurements = []
    if measurement
      measurements << measurement
    end
    group = MeasurementGroup.new(:name => SecureRandom.urlsafe_base64, :group_id => @@order, :project => project, :order => @@order,
      :measurements => measurements)
    @@order += 1
    return group
  end

  def create_cooked_measurement(measurement_group=create_cooked_measurement_group(create_cooked_project),
                                value=1.4, unit_quantifier=getRandomUnit)
    instance = Measurement.new :value => value, :unit_quantifier => unit_quantifier,
                               :classification_quantifier => getRandomClassification,
                               :measurement_group => measurement_group

    return instance
  end

  def create_cooked_purchase(user=create_cooked_user, package=packages(:tenner))
    purchase = Purchase.new :transaction_id => SecureRandom.base64, :user => user, :package => package,
                            :brand => 'Visa', :last_4 => 3124, :exp_month => 2, :exp_year => 2020,
                            :total => package.total
    return purchase
  end

  def create_cooked_top_up_history(period_start, period_end=Time.now.utc, user=create_cooked_user, owed=2)
    instance = TopUpHistory.new :user => user, :owed => owed, :period_start => period_start, :period_end => period_end

    return instance
  end

  def create_cooked_address(house_number="301", street="Mayview Cres", city="Waterloo", postal="n2v1p5", unit='B',
                  location=create_cooked_location)
    ontario = Province.find_by_name "Ontario"
    instance = Address.new house_number: house_number, street_name: street, city: city, province: ontario,
                                      postal_code: postal, apartment: unit, location: location
    return instance
  end

  def create_cooked_location(name=nil, latitude=43.499032, longitude=-80.55443)
    instance = Location.new(latitude: latitude, longitude: longitude, :name => name)

    return instance
  end

  def create_cooked_user_location(user=create_cooked_user, location=create_cooked_location)
    instance = UsersLocation.new :user => user, :location => location

    return instance
  end

  def create_cooked_bid(user=create_cooked_user, purchase=nil, top_up_history=nil, consumed_at=nil)
    category = purchase.nil? ? Category.find_by_name(BID_CATEGORY_FREE) : Category.find_by_name(BID_CATEGORY_PAID)
    available = consumed_at.nil?
    bid = Bid.new(:category => category, :user => user, :purchase => purchase, :top_up_history => top_up_history,
                :available => available, :consumed_at => consumed_at)

    return bid
  end

  def create_cooked_quote(business_user=create_cooked_business_user,
                          project=create_cooked_project(create_cooked_user), publish=true)

    purchase = create_cooked_purchase business_user
    save purchase

    estimate = create_cooked_estimate(nil)

    if publish && !project.published?
      project.publish
    end
    quote = Quote.new :project => project, :business => business_user.business
    quote.estimates << estimate

    return quote
  end

  def create_cooked_estimate(quote=create_cooked_quote)
    estimate = Estimate.new(:summary => create_string(5), :description => create_string(10), :price => 2.14,
                            :duration => 12, :quantifier => Quantifier.first, :quote => quote)

    return estimate
  end

  def create_cooked_notification_template(type=1)
    template = NotificationTemplate.new(:summary_key => SecureRandom.base64,
                                        :body_key => "Body",
                                        :classification => type,
                                        :preference => Preference.first)
    return template
  end

  def create_cooked_notification(user=create_cooked_user, template=create_cooked_notification_template)
    notification = Notification.new(:user => user, :notification_template => template)

    return notification
  end

  def create_cooked_rating(user=create_cooked_user, business=create_cooked_business, rating_definition=RatingDefinition.first,
                           rating=10, comments="He sucked")
    instance = Rating.new(:rating_definition => rating_definition, :user => user, :rating => rating,
                          :comments => comments, :business => business)

    return instance
  end

  def create_cooked_user_acceptance_of_terms(user=create_cooked_user)
    instance = UserAcceptanceOfTerms.new(:user => user, :terms_and_conditions => TermsAndConditions.first)
    return instance
  end

  def create_cooked_promo_code(code="test", start_date=(Time.now.utc - 1.minute), end_date=(Time.now.utc + 1.minute))
    instance = PromoCode.new(:code => code, :start_date => start_date, :end_date => end_date,
                              :category => Category.find_by_name(PROMO_CODE_REGISTRATION),
                              :description=> "Test promo code", :discount => 20)
    return instance
  end

  def create_cooked_feedback
    instance = Feedback.new(name:  "goose", email: "t@t.com", content: "THis is a content yo")

    return instance
  end

  def save_all_pieces_of_quote_but_not_quote(publish_project=false, business_user=create_cooked_business_user, bids=1)
    project=create_cooked_project(create_cooked_user)
    purchase=create_cooked_purchase(business_user, packages(:one))
    quote = create_cooked_quote(business_user, project, publish_project)

    project = quote.project
    save project

    assert project.errors.empty?
    if publish_project
      assert project.published?
    else
      assert project.draft?
    end
    assert_nil quote.id

    user = quote.business.user
    save user

    assert user.errors.empty?
    assert_nil quote.id

    return quote
  end

  def create_string(size)
    return "0"*size
  end

  def save(instance)
    unless instance.save
      puts "#{instance.class.name} errors: #{instance.errors.full_messages}"
    end
  end

  def destroy(instance)
    unless instance.destroy
      puts "#{instance.class.name} errors: #{instance.errors.full_messages}"
    end
  end
end
