class CreateActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_logs do |t|
      t.references :document, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :old_status, null: true, foreign_key: { to_table: :statuses }
      t.references :new_status, null: true, foreign_key: { to_table: :statuses }
      t.text :notes

      t.timestamps
    end
  end
end
