require 'spec_helper'

describe "placeholders/index.html.erb" do
  before(:each) do
    assign(:placeholders, [
      stub_model(Placeholder,
        :key => "Key",
        :value => "Value"
      ),
      stub_model(Placeholder,
        :key => "Key",
        :value => "Value"
      )
    ])
  end

  it "renders a list of placeholders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
