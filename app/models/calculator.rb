require 'random_name_generator'

class Calculator < ApplicationRecord
  validates :name, presence: true
  has_many :players
  has_many :rolls
  belongs_to :user

  # def run_scenario(player1_name, player2_name, die1, die2)
  #   player1 = find_or_add_player(player1_name)
  #   streak(player1)
  #   player2 = find_or_add_player(player2_name)
  #   new_roll = Roll.new(player1, player2, die1, die2)
  #   @rolls.push(new_roll)
  #   log_message(new_roll)

  #   calculate(player1, player2, die1, die2)
  # end

  # def calculate(player1, player2, die1, die2)
    # luck = (die2.to_f / die1.to_f).round(2)
#
  #   player1.one_to_three_wins += 1  if(die1 == 1 && die2 == 3)
  #   player2.three_to_one_losses += 1  if(die1 == 1 && die2 == 3)
  #   player1.update_win(luck: luck)
  #   player2.update_loss(luck: luck)
  # end

  # def calculate_undo(player1, player2, die1, die2)
  #   luck = (die2.to_f / die1.to_f).round(2)

  #   player1.one_to_three_wins -= 1  if(die1 == 1 && die2 == 3)
  #   player2.three_to_one_losses -= 1  if(die1 == 1 && die2 == 3)
  #   player1.update_win(luck: luck, undo: true)
  #   player2.update_loss(luck: luck, undo: true)
  # end

  # def undo_roll
  #   if @rolls.any?
  #     roll = @rolls.pop

  #     calculate_undo(roll.player1, roll.player2, roll.die1, roll.die2)
  #     log_message_undo
  #   else
  #     puts "No rolls yet\n"
  #   end
  # end

  # def log_message(roll)
  #   @log_messages.push(roll.to_s)
  # end

  # def log_message_undo
  #   if !@log_messages.empty?
  #     @log_messages.pop
  #   else
  #     puts 'There are no messages to undo!'
  #   end
  # end

  # def logs
  #   @log_messages
  # end

  # def rolls
  #   @rolls
  # end

  # def random_scenario(player_num, roll_num)
  #   @players = []
  #   @random_names = []
  #   initialize_names(player_num.to_i)

  #   while roll_num > 0
  #     player1 = find_or_add_player(@random_names.sample)
  #     player2 = find_or_add_player(@random_names.sample)
  #     if player1.name != player2.name
  #       run_scenario(player1.name, player2.name, rand(1..3), rand(1..3))
  #       roll_num -= 1
  #     end
  #   end
  # end

  # def streak(player)
  #   if @streak_holder == player.name
  #     player.streak_count += 1
  #     if player.streak_count >= player.streak
  #       player.streak = player.streak_count + 1
  #     end
  #   else
  #     player.streak_count = 0
  #   end
  #   @streak_holder = player.name
  # end

  # def find_or_add_player(name)
  #   player = @players.find { |p| p.name == name }

  #   if !player || @players.empty?
  #     puts "New player (#{name}) added", ''
  #     player = Player.new(name)
  #     @players.push(player)
  #   end

  #   player
  # end

  def sort_players
    return @players.sort_by(&:luck).reverse! if @players
    nil
  end

  # def clear
  #   @players = []
  #   @rolls = []
  #   @log_messages = []
  # end
end

