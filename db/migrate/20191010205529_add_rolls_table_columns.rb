class AddRollsTableColumns < ActiveRecord::Migration[6.0]
  def change
    change_table :rolls do |t|
      t.string :player1
      t.string :player2
      t.string :die1
      t.string :die2
    end
  end
end
