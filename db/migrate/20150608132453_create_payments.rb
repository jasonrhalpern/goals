class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :stripe_cus_token
      t.string :stripe_sub_token
      t.datetime :active_until
      t.references :user, index: true

      t.timestamps
    end
  end
end
