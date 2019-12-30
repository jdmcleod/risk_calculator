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

    ratio = translate_ratio(ratio)

    if ratio == 'three_a_two_d' || ratio == 'two_a_two_d'
      roll_count[ratio]['total'] += 1
      if attacking && number == '2'
        update_values(ratio, 'a_wins_two')
      elsif defending && number == '2'
        update_values(ratio, 'd_wins_two')
      else
        update_values(ratio, 'tie')
      end
    else
      roll_count[ratio]['total'] += 1
      update_values(ratio, 'a_wins') if attacking
      update_values(ratio, 'd_wins') if defending
    end
  end

  def update_values(ratio_key, outcome_key)
    roll_count[ratio_key][outcome_key]["count"] += 1

    standard_percentage = roll_count[ratio_key][outcome_key]["standard_percentage"].to_f
    total = roll_count[ratio_key]["total"].to_f
    count = roll_count[ratio_key][outcome_key]["count"].to_f.round

    roll_count[ratio_key][outcome_key]["actual_percentage"] = total / count
    actual_percentage = roll_count[ratio_key][outcome_key]["actual_percentage"].to_f
    roll_count[ratio_key][outcome_key]["deviation"] = (actual_percentage / standard_percentage).round(4)
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

  def translate_ratio(ratio)
    return 'three_a_two_d' if ratio == '3-2'
    return 'two_a_two_d' if ratio == '2-2'
    return 'one_a_two_d' if ratio == '1-2'
    return 'three_a_one_d' if ratio == '3-1'
    return 'two_a_one_d' if ratio == '2-1'
    return 'one_a_one_d' if ratio == '1-1'
  end
end
