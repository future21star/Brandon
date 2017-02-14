module SqlHelper

  # Dangerous method that should NOT be used unless carefully considered and NEVER to be used with user input
  def self.execute_return(sql, callback)
    data = ActiveRecord::Base.connection.execute(sql)
    rows = []
    data.each { |row|
      rows << callback.call(row)
    }
    return rows
  end
end
