class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :score
      t.references :jeopardy_game, index: true
      t.timestamps
    end
  end
end
