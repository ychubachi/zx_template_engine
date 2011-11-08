require "spec_helper"

describe ValuesController do
  describe "routing" do

    it "routes to #index" do
      get("/values").should route_to("values#index")
    end

    it "routes to #new" do
      get("/values/new").should route_to("values#new")
    end

    it "routes to #show" do
      get("/values/1").should route_to("values#show", :id => "1")
    end

    it "routes to #edit" do
      get("/values/1/edit").should route_to("values#edit", :id => "1")
    end

    it "routes to #create" do
      post("/values").should route_to("values#create")
    end

    it "routes to #update" do
      put("/values/1").should route_to("values#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/values/1").should route_to("values#destroy", :id => "1")
    end

  end
end
