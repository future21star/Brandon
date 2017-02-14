module ParamsHelper
  @logger = MyLogger.factory(self)

  def self.setup_params(params)
    ActionController::Parameters.new(params)
  end

  def self.measurement_groups_params(params)
    setup_params(params).require(:measurement_groups)
  end

  def self.measurement_group_params(sub_params)
    sub_params.permit(:project_id, :group_id, :name, :order, measurements_attributes:
        [:id, :value, :unit_quantifier_id, :classification_quantifier_id])
  end

  def self.get_captcha_response(params)
    return captcha_params(params)[:captcha]
  end

  def self.captcha_params(params)
    setup_params(params).permit(:captcha)
  end

  def self.pictures_params(params)
    setup_params(params).require(:pictures)
  end

  def self.picture_params(sub_params)
    sub_params.permit(:name)
  end

  def self.parse_promo_code_query(params)
    sub_hash = params[:promo_code]
    has_promo = sub_hash.has_key?(:code) && !sub_hash[:code].blank?
    promotion_params = promo_params(params)
    if has_promo
      return PromoCode.is_promo_code_valid(promotion_params[:code], promotion_params[:source])
    else
      return nil
    end
  end

  def self.promo_params(params)
    setup_params(params).require(:promo_code).permit(:code, :source)
  end

  def self.parse_user_preferences(params)
    setup_params(params).require(:user_preferences)
  end

  def self.user_preference_params(sub_params)
    sub_params.permit([:id, :email, :internal])
  end

  def self.business_params(params)
    setup_params(params).require(:business).permit(:user_id, :company_name, :phone_number, :biography, :website)
  end

  def self.communication_params(params)
    setup_params(params).require(:communication).permit(:opt_in)
  end

  def self.business_tag_params(params)
    setup_params(params).require(:business_tags)
  end
end
