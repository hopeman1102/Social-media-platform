class CreatePostLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :post_likes, id: false do |t|

      t.timestamps
    end
    add_reference :post_likes, :post, class_name: "Post", foreign_key: true
    add_reference :post_likes, :user, class_name: "User", foreign_key: true
    add_index :post_likes, [:user_id, :post_id], :unique => true
  end
end
