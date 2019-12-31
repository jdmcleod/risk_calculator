class AddJeopardyGame < ActiveRecord::Migration[6.0]
  def change
    create_table :jeopardy_games do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "name"
      t.references :user, index: true
    end
  end
end
