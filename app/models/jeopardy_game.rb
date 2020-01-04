class JeopardyGame < ApplicationRecord
  validates :name, presence: true
  has_many :categories
  has_many :teams
  belongs_to :user

  scope :public_games, -> { where(public: true) }

  def state
    {
      categories: categories.map(&:state)
    }
  end
end
