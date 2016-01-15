class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :restaurant_name, null: :false
      t.string :restaurant_location, null: :false
      t.string :image_src, null: :false
      t.string :rating, null: :false
      t.text :review_content, null: :false
      t.date :review_date, null: :false

      t.timestamps null: :false
    end
  end
end
