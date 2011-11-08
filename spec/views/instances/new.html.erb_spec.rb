require 'spec_helper'

describe "instances/new.html.erb" do
  before(:each) do
    assign(:instance, stub_model(Instance,
      :template_id => 1
    ).as_new_record)
  end

  it "renders new instance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => instances_path, :method => "post" do
      assert_select "input#instance_template_id", :name => "instance[template_id]"
    end
  end
end
