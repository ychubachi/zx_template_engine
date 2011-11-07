class CreatePlaceholders < ActiveRecord::Migration
  def change
    create_table :placeholders do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
