class Player < ApplicationRecord
  belongs_to :calculator
  has_many :stats

  def update_win(luck:, undo: false)
    update(win_value: undo ? -1 : 1)
    update(luck_value: undo ? -luck : luck)
    update(wins: wins += win_value)
    update(luckwins: luckwins +=luck_value)
    update_ratios(undo: undo)
  end

  def update_loss(luck:, undo: false)
    update(win_value: undo ? -1 : 1)
    update(luck_value: undo ? -luck : luck)
    update(luck_value: luck_value += loss_value)
    update(luck_losses: luck_value += luck_value)
    update_ratios(undo: undo)
  end

  def update_ratios(undo: false)
    ratio = (losses.zero? ? wins.to_f : wins.to_f / losses.to_f).round(2)
    update(ratio: ratio)
    luck = (@lucklosses.zero? ? @luckwins.to_f : @luckwins.to_f / @lucklosses.to_f).round(2)
    update(luck: luck)

    undo ? @stats.pop() : @stats.push([@stats.length + 1, @luck])
  end

  def rolls_and_wins
    return ["Total Rolls", @stats.length], ["Wins", @wins]
  end
end
