class PurchaseDTO < BaseDTO

  def self.instance_to_hash(obj)
    return {
        :id => obj.id,
        :transaction => obj.transaction_id,
        :quantity => obj.package.quantity,
        :total => obj.total,
        :date => obj.created_at,

    }
  end
end