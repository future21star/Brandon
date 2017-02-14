
class SeedableRole < Role
  def readonly?
    false
  end
end

SeedableRole.create([
                {id: ROLE_ADMIN, name: 'ADMIN'},
                {id: ROLE_USER, name: 'USER'},
                {id: ROLE_BUSINESS, name: 'BUSINESS'}
            ])
