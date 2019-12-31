class JeopardyGame < ApplicationRecord
  validates :name, presence: true
  has_many :panels
  belongs_to :user
end
