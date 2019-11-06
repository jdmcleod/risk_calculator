class AddDataToCalculators < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :calculator, index: true
    add_reference :rolls, :calculator, index: true
    add_reference :calculators, :user, index: true
  end
end
