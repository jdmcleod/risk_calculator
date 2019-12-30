require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { Player.create(name: "Test Player") }

  before do
    player.initialize_roll_count
  end

  describe 'update roll' do
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
      end

      it 'Player defends and wins twice' do
        player.input_roll('attacker', player.name, player.name, '3-2', '2')

        expect(player.roll_count['three_a_two_d']['total']).to eq 1
        expect(player.roll_count['three_a_two_d']['d_wins_two']['count']).to eq 1
      end
    end

    describe '2-2' do
      it 'Player doesnt win' do
        player.input_roll(player.name, "defender", "defender", '2-2', '2')

        expect(player.roll_count['two_a_two_d']['total']).to eq 1
        expect(player.roll_count['two_a_two_d']['a_wins_two']['count']).to eq 0
      end

      it 'Player attacks roll and wins twice' do
        player.input_roll(player.name, "defender", player.name, '2-2', '2')

        expect(player.roll_count['two_a_two_d']['total']).to eq 1
        expect(player.roll_count['two_a_two_d']['a_wins_two']['count']).to eq 1
      end

      it 'Player defends and wins twice' do
        player.input_roll('attacker', player.name, player.name, '2-2', '2')

        expect(player.roll_count['two_a_two_d']['total']).to eq 1
        expect(player.roll_count['two_a_two_d']['d_wins_two']['count']).to eq 1
      end
    end

    describe '1-2' do
      it 'Attacker wins' do
        player.input_roll(player.name, "defender", player.name, '1-2', '1')

        expect(player.roll_count['one_a_two_d']['total']).to eq 1
        expect(player.roll_count['one_a_two_d']['a_wins']['count']).to eq 1
      end

      it 'Defender wins' do
        player.input_roll('attacker', player.name, player.name, '1-2', '1')
        expect(player.roll_count['one_a_two_d']['total']).to eq 1
        expect(player.roll_count['one_a_two_d']['d_wins']['count']).to eq 1
      end
    end

    describe '3-1' do
      it 'Attacker wins' do
        player.input_roll(player.name, "defender", player.name, '3-1', '1')

        expect(player.roll_count['three_a_one_d']['total']).to eq 1
        expect(player.roll_count['three_a_one_d']['a_wins']['count']).to eq 1
      end

      it 'Defender wins' do
        player.input_roll('attacker', player.name, player.name, '3-1', '1')
        expect(player.roll_count['three_a_one_d']['total']).to eq 1
        expect(player.roll_count['three_a_one_d']['d_wins']['count']).to eq 1
      end
    end

    describe '2-1' do
      it 'Attacker wins' do
        player.input_roll(player.name, "defender", player.name, '2-1', '1')

        expect(player.roll_count['two_a_one_d']['total']).to eq 1
        expect(player.roll_count['two_a_one_d']['a_wins']['count']).to eq 1
      end

      it 'Defender wins' do
        player.input_roll('attacker', player.name, player.name, '2-1', '1')
        expect(player.roll_count['two_a_one_d']['total']).to eq 1
        expect(player.roll_count['two_a_one_d']['d_wins']['count']).to eq 1
      end
    end

    describe '1-1' do
      it 'Attacker wins' do
        player.input_roll(player.name, "defender", player.name, '1-1', '1')

        expect(player.roll_count['one_a_one_d']['total']).to eq 1
        expect(player.roll_count['one_a_one_d']['a_wins']['count']).to eq 1
      end

      it 'Defender wins' do
        player.input_roll('attacker', player.name, player.name, '1-1', '1')
        expect(player.roll_count['one_a_one_d']['total']).to eq 1
        expect(player.roll_count['one_a_one_d']['d_wins']['count']).to eq 1
      end
    end
  end
end
