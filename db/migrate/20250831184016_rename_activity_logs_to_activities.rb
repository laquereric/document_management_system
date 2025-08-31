class RenameActivityLogsToActivities < ActiveRecord::Migration[8.0]
  def change
    rename_table :activity_logs, :activities
  end
end
