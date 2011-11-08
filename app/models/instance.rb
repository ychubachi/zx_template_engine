class Instance < ActiveRecord::Base
  belongs_to :template
  has_many :values
end
