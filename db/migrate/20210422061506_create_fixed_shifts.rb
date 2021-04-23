class CreateFixedShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :fixed_shifts do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in, null:false
      t.datetime :clock_out, null:false
      t.timestamps
    end
  end
end
