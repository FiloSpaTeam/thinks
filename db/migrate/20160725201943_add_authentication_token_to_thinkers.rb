class AddAuthenticationTokenToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :authentication_token, :string, limit: 30
    add_index :thinkers, :authentication_token, unique: true
  end
end
