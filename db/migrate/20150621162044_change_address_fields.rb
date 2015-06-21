class ChangeAddressFields < ActiveRecord::Migration
  def change
    rename_column :locations, :address_line_1, :address
    remove_column :locations, :address_line_2
  end
end
