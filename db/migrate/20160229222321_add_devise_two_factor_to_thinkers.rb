class AddDeviseTwoFactorToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :encrypted_otp_secret, :string
    add_column :thinkers, :encrypted_otp_secret_iv, :string
    add_column :thinkers, :encrypted_otp_secret_salt, :string
    add_column :thinkers, :consumed_timestep, :integer
    add_column :thinkers, :otp_required_for_login, :boolean
  end
end
