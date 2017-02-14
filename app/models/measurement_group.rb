class MeasurementGroup < BaseModel
  validates_presence_of :name, :group_id, :order, :measurements
  validates_length_of :name, minimum: 3, :maximum => 100
  validates_numericality_of :group_id, :order
  before_destroy :not_last_group
  after_destroy :reorder

  has_many :measurements, :dependent => :destroy
  belongs_to :project

  accepts_nested_attributes_for :measurements

  def reorder
    if self.project
      Project.transaction do
        groups = self.project.measurement_groups
        order = 0
        groups.each { |group|
          unless group.id == self.id
            group.group_id = order
            group.order = order
            unless group.save
              errors.add("failed to update order...." + group.errors.full_messages)
            end
            order += 1
          end
        }
      end
    end
  end

  private
    def not_last_group
      if self.project
        unless self.project.measurement_groups.size > 1
          error = "Unable to delete every measurement group from project"
          logger.warn(error)
          errors.add(:base, error)
          return false
        end
        return true
      end
    end
end
