require "spec_helper"

describe InstancesController do
  describe "routing" do

    it "routes to #index" do
      get("/instances").should route_to("instances#index")
    end

    it "routes to #new" do
      get("/instances/new").should route_to("instances#new")
    end

    it "routes to #show" do
      get("/instances/1").should route_to("instances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/instances/1/edit").should route_to("instances#edit", :id => "1")
    end

    it "routes to #create" do
      post("/instances").should route_to("instances#create")
    end

    it "routes to #update" do
      put("/instances/1").should route_to("instances#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/instances/1").should route_to("instances#destroy", :id => "1")
    end

  end
end
