class Player < ApplicationRecord
  belongs_to :calculator

  def update_win(luck:, undo: false)
    win_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck
    update(wins: self.wins += win_value)
    update(luckwins: self.luckwins += luck_value)
    update_ratios(undo: undo)
  end

  def set_streak_to_zero
    update(streak: 0, streak_count: 0)
  end

  def update_loss(luck:, undo: false)
    loss_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck

    update(losses: self.losses += loss_value)
    update(lucklosses: self.lucklosses += luck_value)
    update_ratios(undo: undo)
  end

  def one_to_three_win
    update(one_to_three_wins: self.one_to_three_wins += 1)
  end

  def three_to_one_loss
    update(three_to_one_wins: self.three_to_one_wins += 1)
  end

  def update_ratios(undo: false)
    ratio = (self.losses.zero? ? self.wins.to_f : self.wins.to_f / self.losses.to_f)
    update(ratio: ratio)
    luck = (self.lucklosses.zero? ? self.luckwins.to_f : self.luckwins.to_f / self.lucklosses.to_f)
    update(luck: luck)
    if undo
      stats.pop()
      update(stats: stats)
    else
      update(stats: stats.push(luck))
    end
  end

  def stats_with_index
    result = []
    stats.each_with_index do |stat, i|
      result.push([i, stat])
    end
    return result
  end

  def rolls_and_wins
    return ["Total Rolls", stats.length], ["Wins", wins]
  end
end
