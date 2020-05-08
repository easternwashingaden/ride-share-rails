class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.integer :driver_id
      t.integer :passenger_id
      t.datetime :date
      t.integer :cost
      t.integer :rating

      t.timestamps
    end
  end
end
