class AddModelToReasons < ActiveRecord::Migration
  def change
    add_column :reasons, :related_type, :string
  end
end
