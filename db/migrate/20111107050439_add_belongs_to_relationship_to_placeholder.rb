class AddBelongsToRelationshipToPlaceholder < ActiveRecord::Migration
  def change
    add_column :placeholders, :template_id, :integer
  end
end
