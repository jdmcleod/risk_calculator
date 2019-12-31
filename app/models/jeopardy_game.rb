class JeopardyGame < ApplicationRecord
  validates :name, presence: true
  has_many :players, dependent: :destroy
  has_many :rolls, dependent: :destroy
  belongs_to :user
  attr_accessor :player_name
end
