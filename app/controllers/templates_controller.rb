require 'zip_replacer'

class TemplatesController < ApplicationController
  # GET /templates
  # GET /templates.json
  def index
    p current_user.id
    @templates = Template.where('user_id = ?', current_user.id)

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
    @template.user_id = current_user.id

    # Append placeholders to the template
    attachment = params[:attachment]
    if attachment && template_file = attachment["file"]
      @template.filename = template_file.original_filename	# ZxTemplate.xlsx
      @template.zip_file_path = template_file.path		# /tmp/RackMultipart....
      # Scan the file for parameters
      zr = ZipReplacer.new('/tmp')
      placeholders = zr.scan(template_file.path)
    end

    respond_to do |format|
      if @template.save
        placeholders.each do |k,v|
          @template.placeholders.create! :key => k, :value => v
        end
        
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
        format.html { redirect_to templates_path, notice: 'Template was successfully updated.' }
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
  
end
