PROJECT = 1
USER = 2
class SpamReport < BaseModel
  include MyLogger
  has_paper_trail


  after_create :log_spam

  def self.report_project(source_id, project_id)
    spam = SpamReport.new(:source_id => source_id, :target_id => project_id, :target_type => PROJECT)
    spam.save
    return spam
  end

  def log_spam
    logger.warn "New spam report created for #{self.inspect}"

  end
end
