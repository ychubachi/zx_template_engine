# -*- coding: utf-8 -*-

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
    # Create a new template
    @template = Template.new(params[:template])
    raise 'Please attach a template file.' if ! @template.zip_file
    @template.basename = File.basename(@template.zip_file.current_path)

    # Scan the file for parameters
    zr = ZipReplacer.new
    placeholders = zr.scan(@template.zip_file.current_path)
    raise 'The template has no placeholders.' if placeholders.empty?

    # Set attributes of the template
    @template.user_id = current_user.id
    raise 'Could not save the template' if ! @template.save

    # Create plaseholders
    placeholders.each do |k,v|
      @template.placeholders.create! :key => k, :value => v
    end

    # Success
    respond_to do |format|
      format.html { redirect_to @template, notice: 'Template was successfully created.' }
      format.json { render json: @template, status: :created, location: @template }
    end

  # rescue => exc
  #   # Failure
  #   logger.debug "rescued: #{exc}"
  #   flash[:alert] = exc.to_s
  #   respond_to do |format|
  #     format.html { render action: "new"}
  #     format.json { render json: @template.errors, status: :unprocessable_entity }
  #   end
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
    @template.remove_zip_file!
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :ok }
    end
  end
  
end
