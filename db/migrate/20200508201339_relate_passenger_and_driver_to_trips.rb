class RelatePassengerAndDriverToTrips < ActiveRecord::Migration[6.0]
  def change
    remove_column :trips, :passenger_id
    remove_column :trips, :driver_id
    add_reference :trips, :passenger, foreign_key: true
    add_reference :trips, :driver, foreign_key: true
  end
end
