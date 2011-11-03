require 'zipruby'
require 'find'

class TemplatesController < ApplicationController
  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @templates }
    end
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    @template = Template.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @template }
    end
  end

  # GET /templates/new
  # GET /templates/new.json
  def new
    @template = Template.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template }
    end
  end

  # GET /templates/1/edit
  def edit
    @template = Template.find(params[:id])
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(params[:template])

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render json: @template, status: :created, location: @template }
      else
        format.html { render action: "new" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.json
  def update
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :ok }
    end
  end

  def upload
    puts '-' * 60 + 'templates/upload'

    # Path
    tmp_file          = params[:template_file]
    tmp_file_path     = tmp_file.path
    new_zip_file_path = "#{::Rails.root.to_s}/public/#{tmp_file.original_filename}"
    zip_file_path     = "#{::Rails.root.to_s}/zx_template/#{tmp_file.original_filename}"
    zip_dir           = "#{zip_file_path}-files"
    new_zip_dir       = "#{zip_file_path}-replaced"

    # Move an upload tmp file to our templates dir
    FileUtils.mv tmp_file_path, zip_file_path
    # Unzip the file
    unzip(zip_file_path, zip_dir)
    # Scan the file for parameters
    placeholders = scan_placeholders(zip_dir)
    # Replace the placeholders # TODO
    replacements = {'name' => 'Chubachi', 'address' => 'Shinagawa'}
#    replacements = {}
    replace_placeholders(zip_dir, replacements, new_zip_dir)
    # Zip them again
    zip(new_zip_dir, new_zip_file_path)

#  rescue => exc
#    puts exc #TODO: redirect to error page
  end
  
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
    puts '#' * 60 + "zip(#{zip_dir},#{zip_file_name}"
    # Zip::Archive.open(zip_file_name, Zip::CREATE | Zip::TRUNC, Zip::NO_COMPRESSION) do |ar|
    #   # ar.add_dir('dir')

    #   Dir.glob("#{zip_dir}/**/*").each do |path|
    #     puts path
    #     new_path = path.gsub(/#{zip_dir}\//, '')
    #     puts new_path
    #     if File.directory?(path)
    #       ar.add_dir(new_path)
    #     else
    #       ar.add_file(new_path, path) # add_file(<entry name>, <source path>)
    #     end
    #   end
    # end
    FileUtils.cd(zip_dir) do
      system("zip -r #{zip_file_name} *")
    end
  end


end
