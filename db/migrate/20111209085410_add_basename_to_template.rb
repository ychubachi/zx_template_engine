class AddBasenameToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :basename, :string
  end
end
