class Value < ActiveRecord::Base
  belongs_to :instance
  belongs_to :placeholder
end
