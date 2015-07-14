class AddTitleToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :title, :string
  end
end
