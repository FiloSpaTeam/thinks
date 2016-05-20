class AddDonateButtonToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :donate_button, :string
  end
end
