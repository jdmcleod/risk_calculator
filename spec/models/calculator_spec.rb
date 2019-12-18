require 'rails_helper'

RSpec.describe Calculator, type: :model do
  describe'calculations'  do
    let(:calculator) { Calculator.new }
    let(:player1) { Player.new(name: "Player 1", calculator: calculator) }
    let(:player2) { Player.new(name: "Player 2", calculator: calculator) }

    it 'calculates correctly', :focus do
      expect(calculator.players.count).to eq 2
    end
  end
end
