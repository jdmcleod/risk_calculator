class AddRollCountToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :roll_count, :json
  end
end
