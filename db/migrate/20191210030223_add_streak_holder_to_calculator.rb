class AddStreakHolderToCalculator < ActiveRecord::Migration[6.0]
  def change
    add_column :calculators, :streak_holder, :string
  end
end
