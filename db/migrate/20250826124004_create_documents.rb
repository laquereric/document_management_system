class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :url
      t.text :content
      t.references :folder, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :status, null: false, foreign_key: true
      t.references :scenario_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
