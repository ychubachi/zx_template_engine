require 'spec_helper'

describe "placeholders/new.html.erb" do
  before(:each) do
    assign(:placeholder, stub_model(Placeholder,
      :key => "MyString",
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new placeholder form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => placeholders_path, :method => "post" do
      assert_select "input#placeholder_key", :name => "placeholder[key]"
      assert_select "input#placeholder_value", :name => "placeholder[value]"
    end
  end
end
