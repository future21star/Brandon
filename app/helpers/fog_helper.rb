
require 'fog'

module FogHelper
# create a connection
  @@connection = Fog::Storage.new({
          # :provider                 => 'AWS',
          # :aws_access_key_id        => YOUR_AWS_ACCESS_KEY_ID,
          # :aws_secret_access_key    => YOUR_AWS_SECRET_ACCESS_KEY
         :local_root => '~/tmp/fog',
          :provider   => 'Local'
    })

  # First, a place to contain the glorious details
  @@directory = @@connection.directories.create(
      :key    => 'data',
      :public => true
  )

  def self.upload(path, unique_name)
    extension = File.extname(path)
    file = @@directory.files.create(
        :key    => unique_name + extension,
        :body   => File.open(path),
        # :body   => "OMG!!! We are creating files now?!?!?",
        :public => true
    )
    return file
  end
end
