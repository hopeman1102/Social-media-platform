class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :image
      t.integer :like_count, default: 0
      t.integer :comment_count, default: 0

      t.timestamps
    end
    add_reference :posts, :user, class_name: "User", foreign_key: true
  end
end
