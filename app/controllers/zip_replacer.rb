require 'find'

class ZipReplacer
  def initialize(tmp_dir)
    @tmp_dir     = "#{tmp_dir}/zip_replacer"
  end

  def scan(file_path)
    unzip_dir = unzip_if_necessary(file_path)

    placeholders = []
    Find.find(unzip_dir) do |file|
      if File.file?(file) && !File.extname(file).eql?('.bin')
        File.open(file) do |f|
          f.each() do |line|
            line.scan(/#\{(.*?)\}/) {
              placeholder = $1
              placeholders << placeholder
            }
          end
        end
      end
    end
    return placeholders
  end

  def replace(file_path, replacements)
    unzip_dir = unzip_if_necessary(file_path)

    basename = File.basename(file_path)
    replace_dir = "#{@tmp_dir}/replaced/#{basename}"

    count = 0
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
                  placeholder = '#{' + k + '}'
                  if ! line.scan(/#{placeholder}/).empty?
                    line.gsub!(/#{placeholder}/, v)
                    count += 1
                  end
                end
                output << line
              end
            end
          end
        end
      end
    end

    zip_file_path = zip(replace_dir)
    return zip_file_path, count
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
      system("unzip #{tmp_file_path} > /dev/null")
      raise 'File not found' if $?.to_i != 0
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
