class CreateGoalTags < ActiveRecord::Migration
  def change
    create_table :goal_tags do |t|
      t.references :goal, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end
