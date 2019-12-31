class JeopardyGame < ApplicationRecord
  validates :name, presence: true
  has_many :categories
  belongs_to :user
end
