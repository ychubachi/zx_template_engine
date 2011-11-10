class Instance < ActiveRecord::Base
  belongs_to :template
  has_many :values
  accepts_nested_attributes_for :values, :allow_destroy => true
end
