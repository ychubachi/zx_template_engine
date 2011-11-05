require 'zip_replacer'

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

    # Path for uploaded file
    template_file    = params[:template_file]
#    puts YAML.dump(template_file)
    tmp_file_path    = template_file.path # /tmp/RackMultipart....
    @original_filename = params[:template_file].original_filename # ZxTemplate.xlsx

    # Scan the file for parameters
    zr = ZipReplacer.new('/tmp')
    placeholders = zr.scan(tmp_file_path)

    # Replace the placeholders
    replacements = {'name' => 'Chubachi', 'address' => 'Shinagawa', 'zip' => '140'}
    zip_file_path, count = zr.replace(tmp_file_path, replacements)

    # Move the file to the public dir
    zip_file_basename = File.basename(zip_file_path)
    FileUtils.mv(zip_file_path, "#{::Rails.root.to_s}/public/#{@original_filename}")

#  rescue => exc
#    puts exc #TODO: redirect to error page
  end
  
end
