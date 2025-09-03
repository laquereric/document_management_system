class MakeDocumentTagsPolymorphic < ActiveRecord::Migration[8.0]
  def up
    # First, add the new polymorphic columns
    add_column :document_tags, :taggable_type, :string
    add_column :document_tags, :taggable_id, :bigint

    # Add index for the new polymorphic columns
    add_index :document_tags, [ :taggable_type, :taggable_id ]

    # Migrate existing data: set all existing document_tags to be for documents
    execute "UPDATE document_tags SET taggable_type = 'Document', taggable_id = document_id"

    # Make the new columns not null
    change_column_null :document_tags, :taggable_type, false
    change_column_null :document_tags, :taggable_id, false

    # Remove the old document_id column
    remove_reference :document_tags, :document, null: false, foreign_key: true

    # Rename the table to be more generic
    rename_table :document_tags, :taggings
  end

  def down
    # Rename table back
    rename_table :taggings, :document_tags

    # Add back the document_id column
    add_reference :document_tags, :document, null: false, foreign_key: true

    # Migrate data back
    execute "UPDATE document_tags SET document_id = taggable_id WHERE taggable_type = 'Document'"

    # Remove polymorphic columns
    remove_index :document_tags, [ :taggable_type, :taggable_id ]
    remove_column :document_tags, :taggable_type
    remove_column :document_tags, :taggable_id
  end
end
