class ValuesController < ApplicationController
  # GET /values
  # GET /values.json
  def index
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @values = Value.where(instance_id: params[:instance_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @values }
    end
  end

  # GET /values/1
  # GET /values/1.json
  def show
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @value = Value.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @value }
    end
  end

  # GET /values/new
  # GET /values/new.json
  def new
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @value = Value.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @value }
    end
  end

  # GET /values/1/edit
  def edit
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @value = Value.find(params[:id])
  end

  # POST /values
  # POST /values.json
  def create
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @value = Value.new(params[:value])

    respond_to do |format|
      if @value.save
        format.html { redirect_to @value, notice: 'Value was successfully created.' }
        format.json { render json: @value, status: :created, location: @value }
      else
        format.html { render action: "new" }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /values/1
  # PUT /values/1.json
  def update
    @template = Template.find(params[:template_id])
    @instance = Instance.find(params[:instance_id])
    @value = Value.find(params[:id])

    respond_to do |format|
      if @value.update_attributes(params[:value])
        format.html { redirect_to template_instance_value_path(@template, @instance, @value), notice: 'Value was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /values/1
  # DELETE /values/1.json
  def destroy
    @value = Value.find(params[:id])
    @value.destroy

    respond_to do |format|
      format.html { redirect_to values_url }
      format.json { head :ok }
    end
  end
end
