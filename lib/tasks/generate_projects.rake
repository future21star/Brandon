ENV['LAT_LONG'] ||= '43.499083, -80.554451'
ENV['USER_ID'] ||= '2'
ENV['PROJECT_STATE'] ||= '2'

require_relative '../../config/environment'
require_relative '../helper'

include Helper

FORMAT = "%F %T"

namespace :test do
  @logger = MyLogger.factory('GenerateProjectsTask')

  desc "Generates N number of projects around your location"
  task :generate_projects => :environment do
    n = ENV['AMOUNT'] ? ENV['AMOUNT'].to_i : 1000
    temp = ENV['LAT_LONG'].split(',')
    user_id = ENV['USER_ID'].to_i
    lat = temp[0].to_f
    long = temp[1].to_f
    @logger.info  "Lat: #{lat}\tLong: #{long}"
    @logger.info  "Generating #{n} projects around Lat: #{lat}, Long: #{long} for user_id: #{user_id}
      for env: #{ENV['RAILS_ENV']}"

    delta = 0.1
    minLat = lat - delta
    minLong = long - delta
    maxLat = lat + delta
    maxLong = long + delta

    now = Time.now
    Project.transaction do
      user = User.find_by_id user_id
      # insert the first one via the model to ensure validation still passes
      create_with_model minLat, minLong, maxLat, maxLong, user
      Project.clear_cache!
      n -= 1
      start_after_id = Location.last.id
      project_after_id = Project.last.id
      values = ''
      count = 0
      n.times do
        if count == 1000
          # flush the data
          run_batch minLat, minLong, maxLat, maxLong, user, values, start_after_id, project_after_id
          start_after_id = Location.last.id
          project_after_id = Project.last.id
          values = ''
          count = 0
        end
        generated =  [rand(minLat..maxLat), rand(minLong..maxLong)]
        values += "(#{generated[0]},#{generated[1]}, now(), now()),"
        count +=1
      end
      unless values.empty?
        run_batch minLat, minLong, maxLat, maxLong, user, values, start_after_id, project_after_id
      end
      done = Time.now
      @logger.info  "running time: #{(done - now) / 1.second} seconds"
    end
  end

  # Usage: "rake test:add_project_to_queue id=2"
  task :add_project_to_queue => :environment do
    project_id = ENV["ID"].to_i
    @logger.info  "Adding project with id #{project_id} back to the scheduled queue"
    CloseProjectJob.enqueue project_id
  end

  def is_published?
    return ENV['PROJECT_STATE'] == '2'
  end

  def run_batch(minLat, minLong, maxLat, maxLong, user, values, start_after_id, project_after_id)
    now = Time.now
    values = clean_value_string values
    sql = "INSERT INTO `locations` (`latitude`, `longitude`, `created_at`, `updated_at`) VALUES #{values}"
    execute(sql)

    title= "'This is a projects title'"
    summary = "'This is a projects summary'"
    locations = execute("Select id from locations where id > #{start_after_id}")
    picture_id = Picture.last.id + 1
    project_values = ''
    user_locations_values = ''
    picture_values = ''
    locations.each { |id|
      id = id[0]
      project_values += "(#{title}, #{summary}, 'test description that needs to be so long that it doesn''t trigger the other validations. If you want a great result, write a great description', #{user.id},#{id}, #{ENV['PROJECT_STATE']},#{is_published? ? "'2016-07-25 21:54:10'" : 'NULL'}, now(), now()),"
      user_locations_values += "(#{id}, #{user.id}, now(), now()),"
      picture_values+= "(#{user.id},'#{generateRandomString + generateRandomString}', 'tiger.jpg', 'image/jpeg', 1010244, now(), now(), now()),"
    }

    project_values = clean_value_string project_values
    sql = "INSERT INTO `projects` (`title`, `summary`, `description`, `user_id`, `location_id`, `state`, `published_at`, `created_at`, `updated_at`) VALUES " + project_values
    execute sql

    user_locations_values = clean_value_string user_locations_values
    sql = "INSERT INTO `users_locations` (`location_id`, `user_id`, `created_at`, `updated_at`) VALUES " + user_locations_values
    execute sql

    picture_values = clean_value_string picture_values
    sql = "INSERT INTO `pictures` (`user_id`, `generated_name`, `a_file_name`, `a_content_type`, `a_file_size`, `a_updated_at`, `created_at`, `updated_at`) VALUES " + picture_values
    execute sql

    measurement_units = Quantifier.by_category(QUANTIFIER_CATEGORY_DISTANCE)
    measurement_types = Quantifier.by_category(QUANTIFIER_CATEGORY_MEASUREMENT)
    quantifier = measurement_units.sample[:id]
    classification = measurement_types.sample[:id]
    tag_id = Tag.last.id
    tag_id2 = Tag.first.id
    picture_url = Picture.last.a.url.sub("original", "thumb")
    group_id = MeasurementGroup.last.id + 1
    metadata = ''
    project_tags = ''
    project_pics = ''
    summaries = ''
    measurement_groups = ''
    measurements = []
    projects = execute("SELECT p.id, l.latitude, l.longitude FROM projects p INNER JOIN locations l ON p.location_id = l.id where p.id > #{project_after_id}")
    group = group_id
    projects.each { |project|
      id = project[0]
      latitude = project[1]
      longitude = project[2]
      metadata += "('#{now.strftime(FORMAT)}',#{quantifier},#{id}, now(), now()),"
      project_tags += "(#{tag_id},#{id}, now(), now()),"
      project_tags += "(#{tag_id2},#{id}, now(), now()),"
      project_pics += "(#{picture_id},#{id},1, now(), now()),"
      summaries += "(#{id},#{latitude},#{longitude},#{picture_id},'#{picture_url}',#{title}, now(), now()),"
      measurement_groups += "('group',#{group},#{id},0, now(), now()),"
      sizes = [rand(minLat..maxLat), rand(minLong..maxLong)]
      measurements << {width: sizes[0].abs, length: sizes[1].abs}
      picture_id+=1
      group+=1
    }
    if is_published?
      summaries = clean_value_string summaries
      summary_sql = "INSERT INTO `project_summaries` (`project_id`, `latitude`, `longitude`, `picture_id`, `picture_url`, `title`, `created_at`, `updated_at`) VALUES " + summaries
      execute summary_sql
    end

    metadata = clean_value_string metadata
    meta_sql = "INSERT INTO `project_meta_data` (`start_date`, `quantifier_id`, `project_id`, `created_at`, `updated_at`) VALUES " + metadata
    execute meta_sql

    project_tags = clean_value_string project_tags
    tags_sql = "INSERT INTO `project_tags` (`tag_id`, `project_id`, `created_at`, `updated_at`) VALUES " + project_tags
    execute tags_sql

    project_pics = clean_value_string project_pics
    pics_sql = "INSERT INTO `project_pictures` (`picture_id`, `project_id`, `default`, `created_at`, `updated_at`) VALUES " + project_pics
    execute pics_sql

    measurement_groups = clean_value_string measurement_groups
    measurement_group_sql = "INSERT INTO `measurement_groups` (`name`, `group_id`, `project_id`, `order`, `created_at`, `updated_at`)VALUES " + measurement_groups
    execute measurement_group_sql

    measurement_values = ''
    measurements.each { |measurement|
      measurement_values +=  "('#{measurement[:width]}',#{quantifier},#{classification},#{group_id}, now(), now()),"
      measurement_values +=  "('#{measurement[:length]}',#{quantifier},#{classification},#{group_id}, now(), now()),"
      group_id += 1
    }

    measurement_values = clean_value_string measurement_values
    measurement_sql = "INSERT INTO `measurements` (`value`, `unit_quantifier_id`, `classification_quantifier_id`, `measurement_group_id`, `created_at`, `updated_at`)VALUES" + measurement_values
    execute measurement_sql

    #We need to inject new projects into redis if they are published
    if is_published?
      upto = Project.last.id
      @logger.info  "Start after: #{project_after_id} to: #{upto}"
      (project_after_id..upto).each { |id|
        CloseProjectJob.enqueue id
      }
    end
  end

  def clean_value_string(sql)
    return sql[0...-1]
  end

  def execute(sql)
    return  ActiveRecord::Base.connection.execute(sql)
  end

  def create_with_model(minLat, minLong, maxLat, maxLong, user)
    generated =  [rand(minLat..maxLat), rand(minLong..maxLong)]
    location = Location.create :latitude => generated[0], :longitude => generated[1]
    project = Helper.create_cooked_project(user, location)
    project.save
    if project.persisted?
      @logger.info  "Generated: #{project.inspect}"
      if ENV['PROJECT_STATE'] == '2'
        project.publish!
      end
    else
      @logger.info  "errors: #{project.errors.full_messages}"
      raise ArgumentError.new "Errors: #{project.errors.full_messages}"
    end
  end
end

