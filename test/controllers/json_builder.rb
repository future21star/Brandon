module JSONBuilder
  def project_create_json
    picture = create_cooked_picture(get_user)
    save picture
    assert picture.errors.empty?

    json = {project: {
        title: "this.state.title",
        summary: "this.state.summary",
        description: create_string(150),
        additional_comments: '',
    },
            project_tags: [{id: Tag.last.id}],
            pictures: [{name: picture.generated_name}],
            measurement_groups: [{
                                     group_id: 0,
                                     order: 0,
                                     name: "group1",
                                     measurements_attributes: [{
                                                                   value: 12,
                                                                   unit_quantifier_id: getRandomUnit,
                                                                   classification_quantifier_id: getRandomClassification,
                                                               }]
                                 }]
            # captcha: this.state.captcha
    }
    json[:location] = LocationDTO.instance_to_hash(create_cooked_location)
    return json
  end

  def project_update_json(new_title = SecureRandom.urlsafe_base64(15), new_summary = SecureRandom.urlsafe_base64(15),
                          new_desc = SecureRandom.urlsafe_base64(150), new_comments = SecureRandom.urlsafe_base64(150))
    return {
        title: new_title,
        summary: new_summary,
        description: new_desc,
        additional_comments: new_comments,
    }
  end

  def valid_promo_code_json(promo_code=PromoCode.first)
    return {
        promo_code:
          { code: promo_code.code, start_date: promo_code.start_date, end_date: promo_code.end_date,
              discount: promo_code.discount, description: promo_code.description},
            category_id: promo_code.category.id
          }
  end

  def business_tags_json
    return {
        business_tags: [{id: Tag.first.id}]
    }
  end

  def user_create_json(business=false)
    json = {
        creating: {
            business: business,
        },
        province: {
            id: Province.first.id,
        },
        # captcha: this.state.captcha
    }
    json[:address] = address_create_json[:address]
    json[:user] = user_update_json[:user]
    json[:user][:password] = 'testuser'
    json[:communication] = communication_json
    return json
  end

  def feedback_json(name='Cookie', email="cookie@test.com", content: 'WE are content')
    json = {
        name: name,
        email: email,
        content: content,
    }
    return json
  end

  def business_user_create_json(promo=nil)
    user_json = user_create_json(true)
    user_json[:business] = {
            company_name: 'Quotr',
            phone_number: '5194965896',
            website: 'Quotr.ca',
            biography: create_string(100),
    }
    user_json = user_json.merge(business_tags_json)

    if promo
      user_json[:promo_code] = {
          code: promo.code,
          source: PromoCode::SOURCE_REGISTRATION
      }
    else
      user_json[:promo_code] = {
          code: '',
          source: ''
      }
    end

    return user_json
  end

  def user_update_json(current_password="testuser", first_name="Cookie", last_name="Monster", email="cookie@nut.now", password='')
    return {
        user: {
            first_name: first_name,
            last_name: last_name,
            email: email,
            password: password,
            confirm_password: password,
            current_password: current_password,
        },
    }
  end

  def business_create_json
    json = business_update_json
    json[:communication] = communication_json
    json = json.merge(business_tags_json)
    return json
  end

  def business_update_json(company_name='new', phone_number='5198229332', website='quotr.ca', biography='new bio bio bio')
    json = {
        business: {
          company_name: company_name,
          phone_number: phone_number,
          website: website,
          biography: biography
        }
    }
    return json
  end

  def communication_json(opt_in=false)
    return {
        opt_in: opt_in
    }
  end

  def address_create_json
    return address_update_json
  end

  def address_update_json(street_name='Mayview Cres', house_number=301, apartment='B', city='Waterloo', postal_code='n2v1p5',
                          province=Province.find_by_code('ON'))
    return {
      address: {
          house_number: house_number,
          street_name: street_name,
          postal_code: postal_code,
          apartment: apartment,
          city: city,
          province_id: province,
      }
    }
  end

  include ActionDispatch::Http
  def picture_create_json
    file_name = 'tiger.jpg'
    tiger = File.open(Rails.root.join('test', file_name))
    file = UploadedFile.new(tempfile: tiger, filename: file_name, type: "image/jpg")
    return {
        file: file
    }
  end

  def user_preference_json(id, email=false, internal=false)
    return {
        user_preferences: [{ id: id, email: email, internal: internal }]
    }
  end

  def location_json(name="name",visible=true)
    return {
        location: {
          name: name,
          visible: visible,
        }
    }
  end

  def my_projects_json
    return {
      page: 1
    }
  end

  def my_estimates_json
    return {
      page: 1
    }
  end

  def package_json(package=Package.first.id)
    return :package => {:id => package}
  end

  def purchase_json(brand='visa', last_4=1231, month=2, year=2018)
    json = package_json
    json[:history] = {
     brand: brand,
     last_4: last_4,
     exp_month: month,
     exp_year: year
    }
    return json
  end
end