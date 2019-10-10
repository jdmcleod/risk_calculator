class Roll < ApplicationRecord
  def to_s
    "#{player1.name} beat #{player2.name} in a #{die1} to #{die2} roll."
  end
end
