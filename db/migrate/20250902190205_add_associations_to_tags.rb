class AddAssociationsToTags < ActiveRecord::Migration[8.0]
  def change
    add_reference :tags, :organization, null: true, foreign_key: true
    add_reference :tags, :team, null: true, foreign_key: true
    add_reference :tags, :folder, null: true, foreign_key: true
  end
end
