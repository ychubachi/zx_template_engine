# -*- coding: utf-8 -*-
require 'find'

# UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

class ZipReplacer
  def initialize
    @tmp_dir = "#{Rails.root}/tmp/zip_replacer"
  end

  def scan(file_path)
    # UTF-8
    file_path.force_encoding('UTF-8')

    # unzip
    unzip_dir = unzip(file_path)

    # scan for placeholders
    placeholders = []
    Find.find(unzip_dir) do |file|
      if File.file?(file) && !File.extname(file).eql?('.bin')
        File.open(file) do |f|
          f.each() do |line|
            line.scan(/#\{(.*?)\}/) {		# PLACEHOLDER
              placeholder = $1
              placeholders << placeholder
            }
          end
        end
      end
    end

    # clean up
    FileUtils.rm_rf(unzip_dir)

    return placeholders
  end

  def replace(file_path, replacements)
    # UTF-8
    file_path.force_encoding('UTF-8')

    # unzip
    unzip_dir = unzip(file_path)

    basename = File.basename(file_path)
    replace_dir = "#{@tmp_dir}/replaced/#{basename}"

    FileUtils.cd(unzip_dir) do
      Find.find('.').each do |file|
        next if not File.file?(file)

        new_file = "#{replace_dir}/#{file}"

        dir_name = File.dirname(new_file)
        FileUtils.mkdir_p(dir_name) unless File.exist?(dir_name)

        if File.extname(file).eql?('.bin')
          FileUtils.cp(file, new_file)
        else 
          File.open(new_file, 'w') do |output|
            File.open(file, 'r') do |input|
              input.each do |line|
                replacements.each do |k,v|
                  puts k
                  next if v == nil
                  placeholder = '#{' + k + '}'	# PLACEHOLDER
                  if ! line.scan(/#{placeholder}/).empty?
                    line.gsub!(/#{placeholder}/, v)
                  end
                end
                output << line
              end
            end
          end
        end
      end
    end

    # zip again
    zip_file_path = zip(replace_dir)

    # clean up
    FileUtils.rm_rf(unzip_dir)
    FileUtils.rm_rf(replace_dir)

    return zip_file_path
  end
  
  private

  def unzip(file_path)
    basename = File.basename(file_path)
    extname = File.extname(file_path)
    if extname == '.zip'
      tmp_file_path = "#{@tmp_dir}/#{basename}"
    else
      tmp_file_path = "#{@tmp_dir}/#{basename}.zip"
    end
    FileUtils.mkdir_p(@tmp_dir) unless File.exist?(@tmp_dir)
    FileUtils.cp(file_path, tmp_file_path)

    unzip_dir   = "#{@tmp_dir}/unzip/#{basename}"
    FileUtils.rm_rf(unzip_dir) if File.exist?(unzip_dir)
    FileUtils.mkdir_p(unzip_dir)
    FileUtils.cd(unzip_dir) do
      system("unzip #{tmp_file_path}")
      raise 'Could not unzip the file' if $?.to_i != 0
    end

    FileUtils.rm_rf(tmp_file_path)
    return unzip_dir
  end
  
  def zip(zip_dir)
    basename = File.basename(zip_dir)
    extname = File.extname(zip_dir)
    zip_file_path = "#{@tmp_dir}/#{basename}.new#{extname}"
    FileUtils.cd(zip_dir) do
      system("zip -r #{zip_file_path} * > /dev/null")
    end
    return zip_file_path
  end
  
  def unzip_if_necessary(file_path)
    basename = File.basename(file_path)
    unzip_dir   = "#{@tmp_dir}/unzip/#{basename}"
    if ! File.directory?(unzip_dir)
      unzip(file_path)
    end
    return unzip_dir
  end
end
