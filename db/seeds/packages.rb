
class SeedablePackage < Package
  def readonly?
    false
  end
end

SeedablePackage.create([
               {name: "loner", quantity: 1, price_per_unit: 12.99, total: 12.99},
               {name: "small", quantity: 5, price_per_unit: 10, total: 50.00},
               {name: "exponent", quantity: 15, price_per_unit: 6, total: 90.00},
               {name: "Biggy", quantity: 45, price_per_unit: 1, total: 45.00},
           ])
