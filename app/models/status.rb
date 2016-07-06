class Status < ActiveRecord::Base
  belongs_to :solution
  enum state: {
    pending: 1,
    success: 2,
    failure: 3
  }
end
