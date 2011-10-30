class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :filename
      t.string :identifier
      t.string :memo

      t.timestamps
    end
  end
end
