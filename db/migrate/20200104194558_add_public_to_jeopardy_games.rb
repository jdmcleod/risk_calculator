class AddPublicToJeopardyGames < ActiveRecord::Migration[6.0]
  def change
    add_column :jeopardy_games, :public, :boolean, default: false
  end
end
