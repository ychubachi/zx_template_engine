class RemoveFilenameFromTemplate < ActiveRecord::Migration
  def up
    remove_column :templates, :filename
  end

  def down
    add_column :templates, :filename, :string
  end
end
