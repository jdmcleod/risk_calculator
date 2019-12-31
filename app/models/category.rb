class Category < ApplicationRecord
  belongs_to :jeopardy_game
  has_many :panels
end
