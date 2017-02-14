module CreationHelper
  @logger = MyLogger.factory(self)

  def self.create_business(params)
    business_params = ParamsHelper.business_params(params)
    communication_params = ParamsHelper.communication_params(params)
    tag_params = ParamsHelper.business_tag_params(params)
    business = Business.new(business_params)
    business.opt_in = communication_params[:opt_in]
    tags = tag_params
    tags.each { |tag|
      business.business_tags << BusinessTag.new(:tag_id => tag[:id])
    }
    return business
  end
end
