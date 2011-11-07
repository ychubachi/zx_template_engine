require 'spec_helper'

describe "placeholders/edit.html.erb" do
  before(:each) do
    @placeholder = assign(:placeholder, stub_model(Placeholder,
      :key => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit placeholder form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => placeholders_path(@placeholder), :method => "post" do
      assert_select "input#placeholder_key", :name => "placeholder[key]"
      assert_select "input#placeholder_value", :name => "placeholder[value]"
    end
  end
end
