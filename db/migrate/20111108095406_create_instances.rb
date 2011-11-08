class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.integer :template_id

      t.timestamps
    end
  end
end
