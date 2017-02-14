
class CloseProjectJob < BaseJob
  @logger = MyLogger.factory(self)
  @queue = :projects
  @class = CloseProjectJob

  def self.validate_request(project_id)
    if project_id.blank?
      raise ArgumentError.new "missing required parameter {project_id}"
    end

    unless project_id.is_a? Integer
      raise ArgumentError.new "{project_Id} expected to be an integer"
    end
  end

  def self.create_params(project_id)
    return [:project_id => project_id]
  end

  def self.perform(params)
    @logger.info "Performing execution of #{@class} with params: #{params.inspect}"
    project_id = params[0]['project_id']
    validate_request project_id

    Project.transaction do
      project = Project.find_by_id! project_id
      unless project
        raise ArgumentError.new "Failed to find project with id #{project_id}"
      end

      if project.cancelled?
        @logger.info "Project #{project_id} was cancelled so nothing to do"
        return true
      end

      unless project.published?
        raise ArgumentError.new "Project with id #{project_id} is not in the published state"
      end

      unless project.published_at
        raise ArgumentError.new "Project #{project_id} does not have its 'published_at' date set somehow"
      end

      closed = project.close!
      unless project.closed?
        raise RuntimeError.new "Failed to move project id: #{project_id} to closed. Errors: #{project.errors.keys}"
      end
      return closed
    end
  end

  def self.enqueue(project_id)
    validate_request project_id
    params = create_params(project_id)
    @logger.info "Creating #{@class} with project_id: #{project_id}"
    # Resque.enqueue_to :projects, @class, params
    enqueue_time = PROJECT_PUBLISH_PERIOD_SECONDS.seconds.from_now
    Resque.enqueue_at_with_queue :projects, enqueue_time, @class, params
  end

  def self.cancel(project_id)
    validate_request project_id
    params = create_params(project_id)
    @logger.info "Cancelling #{@class} with project_id: #{project_id}"
    Resque.remove_delayed @class, params
  end
end
