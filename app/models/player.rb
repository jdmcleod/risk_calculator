class Player < ApplicationRecord
  def update_win(luck:, undo: false)
    win_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck

    @wins += win_value
    @luckwins += luck_value
    update_ratios(undo: undo)
  end

  def update_loss(luck:, undo: false)
    loss_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck

    @losses += loss_value
    @lucklosses += luck_value
    update_ratios(undo: undo)
  end

  def update_ratios(undo: false)
    @ratio = (@losses.zero? ? @wins.to_f : @wins.to_f / @losses.to_f).round(2)
    @luck = (@lucklosses.zero? ? @luckwins.to_f : @luckwins.to_f / @lucklosses.to_f).round(2)

    undo ? @stats.pop() : @stats.push([@stats.length + 1, @luck])
  end

  def rolls_and_wins
    return ["Total Rolls", @stats.length], ["Wins", @wins]
  end
end