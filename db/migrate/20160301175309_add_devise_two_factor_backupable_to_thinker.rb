class AddDeviseTwoFactorBackupableToThinker < ActiveRecord::Migration
  def change
    add_column :thinkers, :otp_backup_codes, :string, array: true
  end
end
