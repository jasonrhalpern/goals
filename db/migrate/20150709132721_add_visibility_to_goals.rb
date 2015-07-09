class AddVisibilityToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :visibility, :integer
  end
end
