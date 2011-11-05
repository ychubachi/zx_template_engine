require 'zipruby'
require 'find'

class ZipReplacer
  def unzip(from_file,to_dir)
    Zip::Archive.open(from_file) do |ar|
      ar.each do |zf|
        name = "#{to_dir}/#{zf.name}"
        if zf.directory?
          FileUtils.mkdir_p(name)
        else
          dirname = File.dirname(name)
          FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
          open(name, 'wb') do |f|
            f << zf.read
          end
        end
      end
    end
  end

  def scan_placeholders zip_dir
    placeholders = []
    Find.find(zip_dir) do |file|
      if File.file?(file) && !File.extname(file).eql?('.bin')
        File.open(file) do |f|
          f.each() do |line|
            line.scan(/#\{(.*?)\}/) {
              placeholders << $1
            }
          end
        end
      end
    end
    placeholders
  end

  def replace_placeholders(zip_dir, replacements, new_zip_dir)
    puts '*' * 60 + 'replace_placeholder'
    Find.find(zip_dir) do |file|
      if File.file?(file)
        new_file = file.gsub(zip_dir, new_zip_dir)
        dir_name = File.dirname(new_file)
        FileUtils.mkdir_p(dir_name) unless File.exist?(dir_name)

        if File.extname(file).eql?('.bin')
          puts "binaryfile=#{file}"
          FileUtils.cp(file, new_file)
        else 
          File.open(new_file, 'w') do |output|
            File.open(file, 'r') do |input|
              input.each do |line|
                replacements.each do |k,v|
                  placeholder = '#{' + k + '}'
#                  puts "placeholder=#{placeholder}"
                  if ! line.scan(/#{placeholder}/).empty?
                    line.gsub!(/#{placeholder}/, v)
                    puts "line=#{line}"
                  end
                end
                output << line
              end
            end
          end
        end
      end
    end
  end

  def zip(zip_dir, zip_file_name)
    FileUtils.cd(zip_dir) do
      system("zip -r #{zip_file_name} *")
    end
  end
end
