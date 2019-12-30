class Roll < ApplicationRecord
  belongs_to :calculator

  def to_s
    won_or_lost = attacker == winner ? 'won' : 'lost'
    "#{attacker} attacked #{defender} in a #{ratio} roll and #{won_or_lost}"
  end
end
