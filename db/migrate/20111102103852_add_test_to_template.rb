class AddTestToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :test, :string
  end
end
