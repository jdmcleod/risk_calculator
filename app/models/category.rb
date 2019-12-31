class Category < ApplicationRecord
  belongs_to :jeopardy_game
  has_many :panels

  def state
    {
      name: name,
      id: id,
      panels: panels
    }
  end
end
