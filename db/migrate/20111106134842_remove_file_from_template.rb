class RemoveFileFromTemplate < ActiveRecord::Migration
  def up
    remove_column :templates, :file
  end

  def down
    add_column :templates, :file, :binary
  end
end
