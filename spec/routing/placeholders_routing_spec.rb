require "spec_helper"

describe PlaceholdersController do
  describe "routing" do

    it "routes to #index" do
      get("/placeholders").should route_to("placeholders#index")
    end

    it "routes to #new" do
      get("/placeholders/new").should route_to("placeholders#new")
    end

    it "routes to #show" do
      get("/placeholders/1").should route_to("placeholders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/placeholders/1/edit").should route_to("placeholders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/placeholders").should route_to("placeholders#create")
    end

    it "routes to #update" do
      put("/placeholders/1").should route_to("placeholders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/placeholders/1").should route_to("placeholders#destroy", :id => "1")
    end

  end
end
