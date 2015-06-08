class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :status, default: 0
      t.string :title
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
