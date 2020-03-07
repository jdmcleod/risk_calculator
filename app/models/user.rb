class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  has_many :calculators
end
