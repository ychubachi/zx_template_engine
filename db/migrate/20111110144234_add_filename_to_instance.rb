class AddFilenameToInstance < ActiveRecord::Migration
  def change
    add_column :instances, :filename, :string
  end
end
