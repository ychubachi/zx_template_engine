require 'spec_helper'

describe "values/show.html.erb" do
  before(:each) do
    @value = assign(:value, stub_model(Value,
      :instance_id => 1,
      :placeholder_id => 1,
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Value/)
  end
end
