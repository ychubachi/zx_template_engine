# encoding: utf-8

class TemplateUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

  # def filename
  #   utf8 = original_filename
  #   utf8.force_encoding('UTF-8')
  # end
end
