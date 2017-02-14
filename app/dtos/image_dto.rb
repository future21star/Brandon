class ImageDTO < BaseDTO

  def self.instance_to_hash(picture)
    return {
        :file_name => picture.a_file_name,
        :generated_name => picture.generated_name,
        :thumbnail_url => picture.a.url(:thumb),
        :url => picture.a.url
    }
  end
end