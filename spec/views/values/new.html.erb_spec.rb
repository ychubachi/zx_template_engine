require 'spec_helper'

describe "values/new.html.erb" do
  before(:each) do
    assign(:value, stub_model(Value,
      :instance_id => 1,
      :placeholder_id => 1,
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new value form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => values_path, :method => "post" do
      assert_select "input#value_instance_id", :name => "value[instance_id]"
      assert_select "input#value_placeholder_id", :name => "value[placeholder_id]"
      assert_select "input#value_value", :name => "value[value]"
    end
  end
end
