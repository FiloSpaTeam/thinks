class CreateJoinTableSkillThinker < ActiveRecord::Migration
  def change
    create_join_table :skills, :thinkers do |t|
      t.index [:skill_id, :thinker_id]
      t.index [:thinker_id, :skill_id]
    end
  end
end
