class ProjectDTO < BaseDTO

  def self.instance_to_hash(project)
    location = LocationDTO.instance_to_hash(project.location)
    tags = []
    project.tags.each { |tag| tags << SimpleDTO.instance_to_hash(tag) }

    pictures = []
    project.pictures.each { |picture|
      pictures << ImageDTO.instance_to_hash(picture)
    }

    measurement_groups = []
    project.measurement_groups.each { |measurement_group|
      measurement_groups << MeasurementGroupDTO.instance_to_hash(measurement_group)
    }
    return {
     :id => project.id,
     :title => project.title,
     :published => project.published_at,
     :summary => project.summary,
     :description => project.description,
     :state => project.state,
     :location => location,
     :tags => tags,
     :images => pictures,
     :additional_comments => project.additional_comments,
     :measurement_groups => measurement_groups
    }
  end
end