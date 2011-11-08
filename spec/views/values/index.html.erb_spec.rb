require 'spec_helper'

describe "values/index.html.erb" do
  before(:each) do
    assign(:values, [
      stub_model(Value,
        :instance_id => 1,
        :placeholder_id => 1,
        :value => "Value"
      ),
      stub_model(Value,
        :instance_id => 1,
        :placeholder_id => 1,
        :value => "Value"
      )
    ])
  end

  it "renders a list of values" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
