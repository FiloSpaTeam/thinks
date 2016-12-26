class AddImpressionsCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :impressions_count, :integer
  end
end
