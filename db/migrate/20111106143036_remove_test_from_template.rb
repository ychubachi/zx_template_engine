class RemoveTestFromTemplate < ActiveRecord::Migration
  def up
    remove_column :templates, :test
  end

  def down
    add_column :templates, :test, :string
  end
end
