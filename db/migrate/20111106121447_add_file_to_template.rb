class AddFileToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :file, :binary
  end
end
