class AddZipFileToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :zip_file, :string
  end
end
