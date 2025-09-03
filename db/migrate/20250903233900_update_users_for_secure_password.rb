class UpdateUsersForSecurePassword < ActiveRecord::Migration[8.0]
  def change
    # Remove Devise-specific columns (indexes are automatically removed with columns)
    remove_column :users, :encrypted_password, :string
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    
    # Add password_digest for has_secure_password
    add_column :users, :password_digest, :string
  end
end
