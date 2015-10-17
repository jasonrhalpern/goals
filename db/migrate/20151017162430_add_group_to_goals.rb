class AddGroupToGoals < ActiveRecord::Migration
  def change
    add_reference :goals, :group, index: true
  end
end
