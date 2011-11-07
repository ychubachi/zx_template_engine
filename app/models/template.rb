class Template < ActiveRecord::Base
  has_many :placeholders, {:dependent => :delete_all}
end
