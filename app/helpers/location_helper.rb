module LocationHelper
  include MyLogger
  @logger = MyLogger.factory(self)
  # Example response
  # {
  #     "address_components"=>[{
  #                                "long_name"=>"N2V 1P5",
  #                                "short_name"=>"N2V 1P5",
  #                                "types"=>["postal_code"]
  #                            },
  #                            {
  #                                "long_name"=>"Waterloo",
  #                                "short_name"=>"Waterloo",
  #                                "types"=>["locality",
  #                                          "political"]
  #                            },
  #                            {
  #                                "long_name"=>"Waterloo Regional Municipality",
  #                                "short_name"=>"Waterloo Regional Municipality",
  #                                "types"=>["administrative_area_level_2",
  #                                          "political"]
  #                            },
  #                            {
  #                                "long_name"=>"Ontario",
  #                                "short_name"=>"ON",
  #                                "types"=>["administrative_area_level_1",
  #                                          "political"]
  #                            },
  #                            {
  #                                "long_name"=>"Canada",
  #                                "short_name"=>"CA",
  #                                "types"=>["country",
  #                                          "political"]
  #                            }],
  #     "formatted_address"=>"Waterloo, ON N2V 1P5, Canada",
  #     "geometry"=>{
  #         "bounds"=>{
  #             "northeast"=>{
  #                 "lat"=>43.4992539,
  #                 "lng"=>-80.5541368
  #             },
  #             "southwest"=>{
  #                 "lat"=>43.4988209,
  #                 "lng"=>-80.5553146
  #             }
  #         },
  #         "location"=>{
  #             "lat"=>43.4989947,
  #             "lng"=>-80.5546957
  #         },
  #         "location_type"=>"APPROXIMATE",
  #         "viewport"=>{
  #             "northeast"=>{
  #                 "lat"=>43.5003863802915,
  #                 "lng"=>-80.55337671970848
  #             },
  #             "southwest"=>{
  #                 "lat"=>43.4976884197085,
  #                 "lng"=>-80.5560746802915
  #             }
  #         }
  #     },
  #     "place_id"=>"ChIJRdMOPWbxK4gRDBQYFcZtBdc",
  #     "types"=>["postal_code"]
  # }
  class GeoLocation
    include MyLogger
    attr_reader :latitude,:longitude
    def initialize(request, api_response)
      if !api_response || api_response.empty?
        msg = "Request: #{request} result in a nil location lookup"
        logger.warn msg
        raise ArgumentError.new msg
      end
      google_obj = api_response[0]
      # puts "Google obj #{google_obj.inspect}"
      # puts "coordinates obj #{google_obj.coordinates}"
      @latitude = google_obj.latitude
      @longitude = google_obj.longitude
      # puts "Location #{self.inspect} "
      # geo_information = google_obj.geometry
      # puts "Geo information: #{geo_information}"
    end
  end

  def self.convert_to_geo_lookup_params(address)
    params = []
    params << address.postal_code unless address.postal_code.nil?
    params << address.house_number unless address.house_number.nil?
    params << address.street_name unless address.street_name.nil?
    params << address.city unless address.city.nil?
    params << address.province.name unless address.province.nil?
    params << address.country_alpha2 unless address.country_alpha2.nil?
    return params.to_s
  end
  def self.geocode_by_address(address)

    params = convert_to_geo_lookup_params(address)
    @logger.info "Geo request by address params: #{params}"
    geo_result = GeoLocation.new(params, Geocoder.search(params))
    return geo_result
  end

  def self.clean_postal_code(postal_code)
    if postal_code
      postal_code = postal_code.upcase.gsub(/\s/,'')
    end
    return postal_code
  end
end
