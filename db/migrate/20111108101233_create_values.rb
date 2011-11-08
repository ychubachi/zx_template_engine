class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer :instance_id
      t.integer :placeholder_id
      t.string :value

      t.timestamps
    end
  end
end
