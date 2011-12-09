class RemoveZipFilePathFromTemplate < ActiveRecord::Migration
  def up
    remove_column :templates, :zip_file_path
  end

  def down
    add_column :templates, :zip_file_path, :string
  end
end
