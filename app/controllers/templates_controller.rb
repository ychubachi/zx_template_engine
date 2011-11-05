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

    # Path
    tmp_file          = params[:template_file]
    tmp_file_path     = tmp_file.path # /tmp/ZxTemplate.xlsx
    new_zip_file_path = "#{::Rails.root.to_s}/public/#{tmp_file.original_filename}"
    zip_file_path     = "#{::Rails.root.to_s}/zx_template/#{tmp_file.original_filename}"
    zip_dir           = "#{zip_file_path}-files"
    new_zip_dir       = "#{zip_file_path}-replaced"

    # Move an upload tmp file to our templates dir
    FileUtils.mv tmp_file_path, zip_file_path

    zr = ZipReplacer.new()
    # Unzip the file
    zr.unzip(zip_file_path, zip_dir)
    # Scan the file for parameters
    placeholders = zr.scan_placeholders(zip_dir)
    # Replace the placeholders # TODO
    replacements = {'name' => 'Chubachi', 'address' => 'Shinagawa'}
    zr.replace_placeholders(zip_dir, replacements, new_zip_dir)
    # Zip them again
    zr.zip(new_zip_dir, new_zip_file_path)

#  rescue => exc
#    puts exc #TODO: redirect to error page
  end
  
end
