require 'spec_helper'

describe "placeholders/show.html.erb" do
  before(:each) do
    @placeholder = assign(:placeholder, stub_model(Placeholder,
      :key => "Key",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Value/)
  end
end
