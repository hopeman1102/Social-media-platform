class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :user_name, null: false
      t.string :bio
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :user_name, :unique => true
  end
end
