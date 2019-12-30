require 'random_name_generator'

class Calculator < ApplicationRecord
  validates :name, presence: true
  has_many :players, dependent: :destroy
  has_many :rolls, dependent: :destroy
  belongs_to :user

  attr_accessor :player_name

  def run_scenario(attacker, defender, winner, ratio, number)
    attacker = players.find_by(name: attacker)
    defender = players.find_by(name: defender)
    attacker.input_roll(attacker, defender, winner, ratio, number)
    defender.input_roll(attacker, defender, winner, ratio, number)
    streak(attacker)
    rolls.build(attacker: attacker.name, defender: defender.name, winner: winner, ratio: ratio, number: number)
  end

  # def calculate_undo(player1_name, player2_name, die1, die2)
  #   player1 = players.find_by(name: player1_name)
  #   player2 = players.find_by(name: player2_name)
  #   luck = (die2.to_f / die1.to_f).round(2)

  #   player1.one_to_three_wins -= 1  if(die1 == 1 && die2 == 3)
  #   player2.three_to_one_losses -= 1  if(die1 == 1 && die2 == 3)
  #   player1.update_win(luck: luck, undo: true)
  #   player2.update_loss(luck: luck, undo: true)
  # end

  # def undo_roll
  #   if rolls.count > 0
  #     roll = rolls.last

  #     calculate_undo(roll.player1, roll.player2, roll.die1, roll.die2)
  #     roll.destroy
  #   else
  #     puts "No rolls yet\n"
  #   end
  # end

  def streak(player)
    if streak_holder == player.name
      player.update(streak_count: player.streak_count + 1)
      if player.streak_count >= player.streak
        player.update(streak: player.streak_count + 1)
      end
    else
      player.update(streak_count: 0)
    end
    update(streak_holder: player.name)
  end

  def sort_players
    return players.sort_by(&:luck).reverse! if players
    nil
  end

   def destroy_players
     self.players.destroy_all
   end

   def destroy_rolls
     self.rolls.destroy_all
   end
end

