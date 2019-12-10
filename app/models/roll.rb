class Roll < ApplicationRecord
  belongs_to :calculator

  def to_s
    "#{player1} beat #{player2} in a #{die1} to #{die2} roll."
  end
end
