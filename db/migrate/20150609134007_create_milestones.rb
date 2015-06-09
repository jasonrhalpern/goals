class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :status, default: 0
      t.text :description
      t.date :reach_by_date
      t.references :goal, index: true

      t.timestamps
    end
  end
end
