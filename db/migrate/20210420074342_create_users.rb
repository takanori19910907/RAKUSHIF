class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :age, null: false
      t.integer :user_id, unique: true, null: false
      t.string :password_digest, null: false
      t.integer :work_status, null: false
      t.boolean :admin, default: false
      t.boolean :license, default: false
      t.boolean :rookie, default: false
      t.timestamps
    end
  end
end
