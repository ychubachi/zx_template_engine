require 'spec_helper'

describe "instances/index.html.erb" do
  before(:each) do
    assign(:instances, [
      stub_model(Instance,
        :template_id => 1
      ),
      stub_model(Instance,
        :template_id => 1
      )
    ])
  end

  it "renders a list of instances" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
