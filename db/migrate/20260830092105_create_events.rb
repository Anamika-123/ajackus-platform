class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :billetto_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :branded_url
      t.string :image_url
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.boolean :available
      t.string :venue_name
      t.string :city
      t.string :organiser
      t.integer :minimum_price_cents
      t.string :currency
      t.string :category

      t.timestamps
    end
    add_index :events, :billetto_id, unique: true
  end
end
