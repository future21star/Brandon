class QuoteDTO < BaseDTO

  def self.instance_to_hash(obj)
    return {
        :id => obj.id,
        :project => obj.project.title,
        :type => obj.bid.category.name,
        :date => obj.created_at,
    }
  end
end