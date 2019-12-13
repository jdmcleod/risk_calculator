class AddStatsToPlayer < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :stats, :json
  end
end
