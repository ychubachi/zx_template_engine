require 'carrierwave/orm/activerecord'

class Template < ActiveRecord::Base
  belongs_to :user
  has_many :placeholders, {:dependent => :delete_all}
  accepts_nested_attributes_for :placeholders, :allow_destroy => true
  has_many :instances, {:dependent => :delete_all}
  accepts_nested_attributes_for :instances, :allow_destroy => true

  mount_uploader :zip_file, TemplateUploader
end
