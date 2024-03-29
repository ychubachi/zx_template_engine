require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PlaceholdersController do

  # This should return the minimal set of attributes required to create a valid
  # Placeholder. As you add validations to Placeholder, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all placeholders as @placeholders" do
      placeholder = Placeholder.create! valid_attributes
      get :index
      assigns(:placeholders).should eq([placeholder])
    end
  end

  describe "GET show" do
    it "assigns the requested placeholder as @placeholder" do
      placeholder = Placeholder.create! valid_attributes
      get :show, :id => placeholder.id
      assigns(:placeholder).should eq(placeholder)
    end
  end

  describe "GET new" do
    it "assigns a new placeholder as @placeholder" do
      get :new
      assigns(:placeholder).should be_a_new(Placeholder)
    end
  end

  describe "GET edit" do
    it "assigns the requested placeholder as @placeholder" do
      placeholder = Placeholder.create! valid_attributes
      get :edit, :id => placeholder.id
      assigns(:placeholder).should eq(placeholder)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Placeholder" do
        expect {
          post :create, :placeholder => valid_attributes
        }.to change(Placeholder, :count).by(1)
      end

      it "assigns a newly created placeholder as @placeholder" do
        post :create, :placeholder => valid_attributes
        assigns(:placeholder).should be_a(Placeholder)
        assigns(:placeholder).should be_persisted
      end

      it "redirects to the created placeholder" do
        post :create, :placeholder => valid_attributes
        response.should redirect_to(Placeholder.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved placeholder as @placeholder" do
        # Trigger the behavior that occurs when invalid params are submitted
        Placeholder.any_instance.stub(:save).and_return(false)
        post :create, :placeholder => {}
        assigns(:placeholder).should be_a_new(Placeholder)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Placeholder.any_instance.stub(:save).and_return(false)
        post :create, :placeholder => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested placeholder" do
        placeholder = Placeholder.create! valid_attributes
        # Assuming there are no other placeholders in the database, this
        # specifies that the Placeholder created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Placeholder.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => placeholder.id, :placeholder => {'these' => 'params'}
      end

      it "assigns the requested placeholder as @placeholder" do
        placeholder = Placeholder.create! valid_attributes
        put :update, :id => placeholder.id, :placeholder => valid_attributes
        assigns(:placeholder).should eq(placeholder)
      end

      it "redirects to the placeholder" do
        placeholder = Placeholder.create! valid_attributes
        put :update, :id => placeholder.id, :placeholder => valid_attributes
        response.should redirect_to(placeholder)
      end
    end

    describe "with invalid params" do
      it "assigns the placeholder as @placeholder" do
        placeholder = Placeholder.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Placeholder.any_instance.stub(:save).and_return(false)
        put :update, :id => placeholder.id, :placeholder => {}
        assigns(:placeholder).should eq(placeholder)
      end

      it "re-renders the 'edit' template" do
        placeholder = Placeholder.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Placeholder.any_instance.stub(:save).and_return(false)
        put :update, :id => placeholder.id, :placeholder => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested placeholder" do
      placeholder = Placeholder.create! valid_attributes
      expect {
        delete :destroy, :id => placeholder.id
      }.to change(Placeholder, :count).by(-1)
    end

    it "redirects to the placeholders list" do
      placeholder = Placeholder.create! valid_attributes
      delete :destroy, :id => placeholder.id
      response.should redirect_to(placeholders_url)
    end
  end

end
