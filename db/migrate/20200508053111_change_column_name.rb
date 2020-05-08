class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :passengers, :phone, :phone_num
  end
end
