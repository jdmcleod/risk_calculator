class Roll < ApplicationRecord
  belongs_to :calculator

  def to_s
    won_or_lost = attacker == winner ? 'won' : 'lost'
    if won_or_lost == 'won' || 'lost'
      "#{attacker} attacked #{defender} in a #{ratio} roll and #{won_or_lost}"
    else
      "#{attacker} attacked #{defender} in a #{ratio} roll and tied"
    end
  end
end
