class MeasurementsController < ApplicationController
  public_routes = []
  user_routes = [:create_group, :destroy, :destroy_group, :update_group]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :authenticate_user!
  before_action :user_only

  def create_group
    MeasurementGroup.transaction do
      measurement_group = ParamsHelper.measurement_group_params(params)
      group = MeasurementGroup.new(measurement_group)
      if group.save
        response = MeasurementGroupDTO.instance_to_hash(group)
        render head: :ok, json: response
      else
        logger.warn "Trying to update group {#{group.inspect}} resulted in errors: #{group.errors.full_messages}"
        errors =  errors_to_hash(group)
        render json: errors, status: :unprocessable_entity
      end
        # FIXME: Validate that the quantifiers belong to the right categories
    end
  end

  def update_group
    @group = MeasurementGroup.find(params[:id])
    updated_params = ParamsHelper.measurement_group_params(params)
    if @group.update(updated_params)
      render head: :ok, json: MeasurementGroupDTO.instance_to_hash(@group)
    else
      logger.warn "Trying to update group {#{@group.inspect}} resulted in errors: #{@group.errors.full_messages}"
      errors =  errors_to_hash(@group)
      render json: errors, status: :unprocessable_entity
    end
  end

  def destroy_group
    @group = MeasurementGroup.find(params[:id])
    if @group.destroy
      render head: :ok, json: {}
    else
      logger.warn "Trying to delete group {#{@group.inspect}} resulted in errors: #{@group.errors.full_messages}"
      errors =  errors_to_hash(@group)
      render json: errors, status: :unprocessable_entity
    end
  end

  def destroy
    measurement = Measurement.find(params[:id])
    if measurement.measurement_group.measurements.size > 1
      if measurement.destroy
        render head: :ok, json: {}
      else
        logger.warn "Trying to delete measurement {#{measurement.inspect}} resulted in errors: #{measurement.errors.full_messages}"
        errors =  errors_to_hash(measurement)
        render json: errors, status: :unprocessable_entity
      end
    else
      logger.warn "Trying to delete last measurement in group {#{measurement.inspect}} "
      errors =  {:base => 'Unable to delete every measurement from measurement group'}
      render json: errors, status: :unprocessable_entity
    end
  end
end
