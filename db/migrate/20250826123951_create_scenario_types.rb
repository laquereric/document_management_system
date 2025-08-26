class CreateScenarioTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :scenario_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
