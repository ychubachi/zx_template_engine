class PlaceholdersController < ApplicationController
  # GET /placeholders
  # GET /placeholders.json
  def index
    @template = Template.find(params[:template_id])
    @placeholders = Placeholder.where(:template_id => params[:template_id])

=begin
    # A place holder is like 'A01.address', 'B01.name'
    # {"A"=>[<address>], "B"=>[<name>,<zip>]}
    @groups = {}
    @placeholders.each do |p|
      key = p.key
      # puts "key=#{key}"
      m = key.match(/([A-Z])([0-9]*)\.(.*)/)
      group  = m[1]
      number = m[2]
      label  = m[3]
      if @groups[group] == nil
        @groups[group] = [p]
      else
        @groups[group] << p
      end
    end
=end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @placeholders }
    end
  end

  # GET /placeholders/1
  # GET /placeholders/1.json
  def show
    @template = Template.find(params[:template_id])
    @placeholder = Placeholder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @placeholder }
    end
  end

  # GET /placeholders/new
  # GET /placeholders/new.json
  def new
    @template = Template.find(params[:template_id])
    @placeholder = Placeholder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @placeholder }
    end
  end

  # GET /placeholders/1/edit
  def edit
    @template = Template.find(params[:template_id])
    @placeholder = Placeholder.find(params[:id])
  end

  # POST /placeholders
  # POST /placeholders.json
  def create
    @template = Template.find(params[:template_id])
    @placeholder = Placeholder.new(params[:placeholder])

    respond_to do |format|
      if @placeholder.save
        format.html { redirect_to @placeholder, notice: 'Placeholder was successfully created.' }
        format.json { render json: @placeholder, status: :created, location: @placeholder }
      else
        format.html { render action: "new" }
        format.json { render json: @placeholder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /placeholders/1
  # PUT /placeholders/1.json
  def update
    @template = Template.find(params[:template_id])
    @placeholder = Placeholder.find(params[:id])

    respond_to do |format|
      if @placeholder.update_attributes(params[:placeholder])
        format.html { redirect_to template_placeholders_path(@template), notice: 'Placeholder was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @placeholder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placeholders/1
  # DELETE /placeholders/1.json
  def destroy
    @placeholder = Placeholder.find(params[:id])
    @placeholder.destroy

    respond_to do |format|
      format.html { redirect_to placeholders_url }
      format.json { head :ok }
    end
  end
end
