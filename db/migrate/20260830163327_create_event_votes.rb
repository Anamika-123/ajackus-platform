class CreateEventVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :event_votes do |t|
      t.references :event, null: false, foreign_key: true
      t.string :user_id
      t.string :vote_type

      t.timestamps
    end
     add_index :event_votes,
              [ :event_id, :user_id ],
              unique: true
  end
end
