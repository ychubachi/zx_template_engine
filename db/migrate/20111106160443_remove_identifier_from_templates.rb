class RemoveIdentifierFromTemplates < ActiveRecord::Migration
  def up
    remove_column :templates, :identifier
  end

  def down
    add_column :templates, :identifier, :string
  end
end
