class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :content

      t.timestamps
    end
    add_reference :comments, :post, class_name: "Post", foreign_key: true
    add_reference :comments, :user, class_name: "User", foreign_key: true
  end
end
