class ChangeToDecimal < ActiveRecord::Migration[6.0]
  def change
    change_column :players, :luckwins, :decimal
    change_column :players, :lucklosses, :decimal
  end
end
