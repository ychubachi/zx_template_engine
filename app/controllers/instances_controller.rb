class InstancesController < ApplicationController
  # GET /instances
  # GET /instances.json
  def index
    @template = Template.find(params[:template_id])
    @instances = Instance.where(:template_id => params[:template_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    @template = Template.find(params[:template_id])
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/1/edit
  def edit
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:id])
  end

  # POST /instances
  # POST /instances.json
  def create
    @template = Template.find(params[:instance][:template_id])
    @instance = Instance.new(params[:instance])

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
        
        format.html { redirect_to template_instance_path(@template, @instance), notice: 'Instance was successfully created.' }
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
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:id])

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        format.html { redirect_to @instance, notice: 'Instance was successfully updated.' }
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
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to instances_url }
      format.json { head :ok }
    end
  end
end
