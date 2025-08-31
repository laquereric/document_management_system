class RenameScenarioTypesToScenarios < ActiveRecord::Migration[8.0]
  def change
    # Rename the table
    rename_table :scenario_types, :scenarios
    
    # Update the foreign key in documents table
    rename_column :documents, :scenario_type_id, :scenario_id
  end
end
