# -*- coding: utf-8 -*-
class InstancesController < ApplicationController
  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.where(:template_id => params[:template_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    @instance = Instance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/new
  # GET /instances/new.json
  def new
    @template = Template.find(params[:template_id])
    @instance = Instance.new
    @instance.template = @template

    day = Date.today
    @instance.filename = "#{day} #{@template.basename}"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/1/edit
  def edit
    @instance = Instance.find(params[:id])
  end

  # POST /instances
  # POST /instances.json
  def create
    @template = Template.find(params[:template_id])
    @instance = Instance.new(params[:instance])
    @instance.template = @template

    respond_to do |format|
      if @instance.save

        @template.placeholders.each do |placeholder|
          puts placeholder
          value = Value.new
          value.instance_id = @instance.id
          value.placeholder_id = placeholder.id
          value.value = placeholder.value
          value.save
        end
        
        format.html { redirect_to instance_values_path(@instance),
          notice: 'Instance was successfully created.' }
        format.json { render json: @instance, status: :created, location: @instance }
      else
        format.html { render action: "new" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.json
  def update
    @instance = Instance.find(params[:id])

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        format.html { redirect_to template_instances_path(@instance.template), notice: 'Instance was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    @instance = Instance.find(params[:id])
    template = @instance.template
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to template_instances_path(template) }
      format.json { head :ok }
    end
  end

  # GET /instances/1.generate
  def generate
    @instance = Instance.find(params[:id])

    # Generate replacements by getting key and value pairs from placeholder.
    replacements = {}
    @instance.values.each do |value|
      key = value.placeholder.key # </w:t></w:r><w:r w:rsidR="002F6123"><w:rPr><w:rFonts w:hint="eastAsia"/><w:szCs w:val="21"/></w:rPr><w:t>請求月</w:t></w:r><w:r w:rsidR="002F6123"><w:rPr><w:rFonts w:hint="eastAsia"/><w:szCs w:val="21"/></w:rPr><w:t>
      logger.debug 'key = ' + key
      striped_key = key.gsub(/<[^>]*>/ui,'') # "請求月"
      text_value = value.value # "1"
      value = key.gsub(/#{striped_key}/, text_value) # </w:t></w:r><w:r w:rsidR="002F6123"><w:rPr><w:rFonts w:hint="eastAsia"/><w:szCs w:val="21"/></w:rPr><w:t>1</w:t></w:r><w:r w:rsidR="002F6123"><w:rPr><w:rFonts w:hint="eastAsia"/><w:szCs w:val="21"/></w:rPr><w:t>
      logger.debug 'key = ' + key
      logger.debug 'value = ' + value
      replacements[key] = value
    end

    # Replace the placeholders
    zr = ZipReplacer.new
    zip_file_path = zr.replace(@instance.template.zip_file.current_path, replacements)

    # Move the file to the public dir
    generated_file_dir = "#{::Rails.root.to_s}/public/generated"
    if ! File.exist?(generated_file_dir)
      FileUtils.mkdir(generated_file_dir)
    end
    public_file_path = "#{generated_file_dir}/#{@instance.filename}"
    FileUtils.mv(zip_file_path, public_file_path)
    @download = "/generated/#{@instance.filename}"
  end

  def email
    @instance = Instance.find(params[:id])

    public_file_path = File.join(Rails.root.to_s, 'public', 'generated', @instance.filename)

    # Sending an email
    mailer = UserMailer.welcome_email(current_user)
    mailer.attachments[@instance.filename] = File.read(public_file_path)
    mailer.deliver
  end
end
