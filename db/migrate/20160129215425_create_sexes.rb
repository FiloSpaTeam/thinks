class CreateSexes < ActiveRecord::Migration
  def change
    create_table :sexes do |t|
      t.string :t_name
    end
  end
end
