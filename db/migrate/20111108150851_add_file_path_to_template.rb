class AddFilePathToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :zip_file_path, :string
  end
end
