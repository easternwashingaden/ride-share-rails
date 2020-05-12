class ChangeColumnDataType < ActiveRecord::Migration[6.0]
  def change
    change_column :trips, :cost, :decimal
  end
end
