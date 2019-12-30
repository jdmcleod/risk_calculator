class Player < ApplicationRecord
  belongs_to :calculator

  def initialize_roll_count
    update(roll_count: {
      three_a_two_d: {
        total: 0,
        a_wins_two: {
          count: 0,
          standard_percentage: 37.17,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins_two: {
          count: 0,
          standard_percentage: 29.26,
          actual_percentage: 0,
          deviation: 0
        },
        tie: {
          count: 0,
          standard_percentage: 33.58,
          actual_percentage: 0,
          deviation: 0
        }
      },
      two_a_two_d: {
        total: 0,
        a_wins_two: {
          count: 0,
          standard_percentage: 22.76,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins_two: {
          count: 0,
          standard_percentage: 44.83,
          actual_percentage: 0,
          deviation: 0
        },
        tie: {
          count: 0,
          standard_percentage: 32.41,
          actual_percentage: 0,
          deviation: 0
        }
      },
      one_a_two_d: {
        total: 0,
        a_wins: {
          count: 0,
          standard_percentage: 25.46,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins: {
          count: 0,
          standard_percentage: 74.54,
          actual_percentage: 0,
          deviation: 0
        }
      },
      three_a_one_d: {
        total: 0,
        a_wins: {
          count: 0,
          standard_percentage: 65.97,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins: {
          count: 0,
          standard_percentage: 34.03,
          actual_percentage: 0,
          deviation: 0
        }
      },
      two_a_one_d: {
        total: 0,
        a_wins: {
          count: 0,
          standard_percentage: 57.87,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins: {
          count: 0,
          standard_percentage: 42.13,
          actual_percentage: 0,
          deviation: 0
        }
      },
      one_a_one_d: {
        total: 0,
        a_wins: {
          count: 0,
          standard_percentage: 41.67,
          actual_percentage: 0,
          deviation: 0
        },
        d_wins: {
          count: 0,
          standard_percentage: 58.33,
          actual_percentage: 0,
          deviation: 0
        }
      }
    })
  end

  def input_roll(attacker, defender, winner, ratio, number)
    attacking = (attacker == name && winner == name)
    defending = (defender == name && winner == name)
    won = winner == name

    if ratio == '3-2'
      roll_count["three_a_two_d"]["total"] += 1
      if attacking && number == '2'
        roll_count["three_a_two_d"]["a_wins_two"]["count"] += 1
        standard_percentage = roll_count["three_a_two_d"]["a_wins_two"]["standard_percentage"].to_f
        total = roll_count["three_a_two_d"]["total"].to_f
        count = roll_count["three_a_two_d"]["a_wins_two"]["count"].to_f
        roll_count["three_a_two_d"]["a_wins_two"]["actual_percentage"] = total / count
        actual_percentage = roll_count["three_a_two_d"]["a_wins_two"]["actual_percentage"].to_f
        roll_count["three_a_two_d"]["a_wins_two"]["deviation"] = standard_percentage / actual_percentage
      elsif defending && number == '2'
        roll_count["three_a_two_d"]["d_wins_two"]["count"] += 1
      else
        roll_count["three_a_two_d"]["tie"]["count"] += 1
      end
    end
    # binding.pry
  end

  def update_win(luck:, undo: false)
    win_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck
    update(wins: self.wins += win_value)
    update(luckwins: self.luckwins += luck_value)
    update_ratios(undo: undo)
  end

  def update_loss(luck:, undo: false)
    loss_value = undo ? -1 : 1
    luck_value = undo ? -luck : luck

    update(losses: self.losses += loss_value)
    update(lucklosses: self.lucklosses += luck_value)
    update_ratios(undo: undo)
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

  def set_streak_to_zero
    update(streak: 0, streak_count: 0)
  end

  def one_to_three_win
    update(one_to_three_wins: self.one_to_three_wins += 1)
  end

  def three_to_one_loss
    update(three_to_one_wins: self.three_to_one_wins += 1)
  end

  def rolls_and_wins
    return ["Total Rolls", stats.length], ["Wins", wins]
  end
end
