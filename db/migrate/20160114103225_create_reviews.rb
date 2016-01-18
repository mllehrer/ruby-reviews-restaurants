class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.string :review_title, null: :false
      t.string :image
      t.string :restaurant_name, null: :false
      t.float :latitude, null: :false
      t.float :longitude, null: :false
      t.string :rating, null: :false
      t.string :price, null: :false
      t.text :review_content, null: :false
      t.string :signature, null: :false
      t.string :tag1
      t.string :tag2
      t.string :tag3

      t.timestamps null: :false
    end
  end
end
