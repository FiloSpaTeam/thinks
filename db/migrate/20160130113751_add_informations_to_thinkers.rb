class AddInformationsToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :born_at, :date
    add_column :thinkers, :photo_id, :string

    add_reference :thinkers, :sex, index: true
  end
end
