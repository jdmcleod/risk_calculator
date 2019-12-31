class JeopardyGame < ApplicationRecord
  validates :name, presence: true
  has_many :categories
  has_many :teams
  belongs_to :user

  def state
    {
      categories: categories.map(&:state)
    }
  end
end
