class Template < ActiveRecord::Base
  has_many :placeholders, {:dependent => :delete_all}
  accepts_nested_attributes_for :placeholders, :allow_destroy => true
  has_many :instances, {:dependent => :delete_all}
  accepts_nested_attributes_for :instances, :allow_destroy => true
end
