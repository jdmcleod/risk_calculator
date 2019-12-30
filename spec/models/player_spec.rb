require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { Player.create(name: "Test Player") }

  before do
    player.initialize_roll_count
  end

  fdescribe 'update roll' do
    describe '3-2' do
      it 'Player doesnt win' do
        player.input_roll(player.name, "defender", "defender", '3-2', '2')

        expect(player.roll_count['three_a_two_d']['total']).to eq 1
        expect(player.roll_count['three_a_two_d']['a_wins_two']['count']).to eq 0
      end

      it 'Player attacks roll and wins twice' do
        player.input_roll(player.name, "defender", player.name, '3-2', '2')

        expect(player.roll_count['three_a_two_d']['total']).to eq 1
        expect(player.roll_count['three_a_two_d']['a_wins_two']['count']).to eq 1
        binding.pry
      end

      it 'Player defends and wins twice' do
        player.input_roll('attacker', player.name, player.name, '3-2', '2')

        expect(player.roll_count['three_a_two_d']['total']).to eq 1
        expect(player.roll_count['three_a_two_d']['d_wins_two']['count']).to eq 1
      end
    end
  end
end
