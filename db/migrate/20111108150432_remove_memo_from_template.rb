class RemoveMemoFromTemplate < ActiveRecord::Migration
  def up
    remove_column :templates, :memo
  end

  def down
    add_column :templates, :memo, :string
  end
end
