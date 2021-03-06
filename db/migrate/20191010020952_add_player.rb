class AddPlayer < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.decimal :ratio
      t.decimal :luck
      t.integer :wins
      t.integer :losses
      t.integer :luckwins
      t.integer :lucklosses
      t.integer :one_to_three_wins
      t.integer :three_to_one_wins
      t.integer :streak
      t.integer :streak_count
    end
  end
end
