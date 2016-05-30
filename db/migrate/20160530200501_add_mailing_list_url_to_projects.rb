class AddMailingListUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :mailing_list_url, :string
  end
end
