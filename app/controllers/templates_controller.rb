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
    uploaded_file = params[:template_file]
    #    puts uploaded_file.class.instance_methods
    # Move an upload tmp file to our templates dir
    new_file_path = "#{::Rails.root.to_s}/zx_template/#{uploaded_file.original_filename}"
    FileUtils.mv uploaded_file.path, new_file_path

    # Unzip the file
    zip_dir = unzip(new_file_path)

    # Scan the file for parameters
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
    p placeholders

  rescue => exc
    puts exc #TODO: redirect to error page
  end
  
  def unzip zip_file_path
    zip_dir = "#{zip_file_path}-files"
    Zip::Archive.open(zip_file_path) do |ar|
      ar.each do |zf|
        name = "#{zip_dir}/#{zf.name}"
        if zf.directory?
          FileUtils.mkdir_p()
        else
          dirname = File.dirname(name)
          FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

          open(name, 'wb') do |f|
            f << zf.read
          end
        end
      end
    end
    zip_dir
  end
end
