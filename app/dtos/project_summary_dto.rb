class ProjectSummaryDTO < BaseDTO

  def self.instance_to_hash(obj)
    # FIXME: Hook these up
    mine = Random.srand % 2 == 0
    quoted = !mine
    return {
        :id => obj.id,
        :latitude => obj.latitude,
        :longitude => obj.longitude,
        :project_id => obj.project_id,
        :picture_id => obj.picture_id,
        :title => obj.title,
        :picture_url => obj.picture_url,
        :mine => mine,
        :quoted => quoted,
    }
  end
end