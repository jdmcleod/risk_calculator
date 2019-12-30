class ChangeRollTable < ActiveRecord::Migration[6.0]
  def change
    change_table :rolls do |t|
      t.string "attacker"
      t.string "defender"
      t.string "winner"
      t.string "ratio"
      t.integer "number"
    end
  end
end
