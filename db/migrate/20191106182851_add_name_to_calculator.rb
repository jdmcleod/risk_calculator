class AddNameToCalculator < ActiveRecord::Migration[6.0]
  def change
    add_column :calculators, :name, :string
  end
end
