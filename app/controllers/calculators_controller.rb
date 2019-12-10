class CalculatorsController < ApplicationController
  def index
    @calculator = self
  end

  def new
    @calculator = Calculator.new
  end

  def show
    @calculator = Calculator.find(params[:id])
    @roll = @calculator.rolls.build
  end

  def create
    @calculator = Calculator.new(name: params[:calculator][:name], user: current_user)
    if @calculator.save
      flash[:success] = "Game created"
      redirect_to @calculator
    else
      render 'new'
    end
  end

  def add_player
    @calculator = Calculator.find(params[:id])
    name = params[:calculator][:player_name]
    player = @calculator.players.find_by(name: name)

    if !player || @calculator.players.count == 0
      flash[:success] = "Player #{name} added"
      player = @calculator.players.build(name: name, wins: 0, losses: 0, ratio: 0, luck: 0,
        luckwins: 0, lucklosses: 0, one_to_three_wins: 0, three_to_one_wins: 0)
      player.set_streak_to_zero
    else
      flash[:warning] = "#{name} already exists"
    end


    @calculator.save

    redirect_to calculator_path
  end

  def remove_player
    @calculator = Calculator.find(params[:id])
    player = @calculator.players.find_by(name: params[:name]).destroy
    flash[:danger] = "#{player.name} removed"
    @calculator.save

    redirect_to @calculator
  end

  def destroy
    @calculator = Calculator.find(params[:id])
    if @calculator.destroy
      redirect_to calculators_path, flash: { success: "#{@calculator.name} deleted" }
    else
      render :index, flash: { error: "#{@calculator.name} could not be deleted" }
    end
  end

  def clear
    @calculator = Calculator.find(params[:id])
    @calculator.destroy_players
    @calculator.destroy_rolls

    redirect_to @calculator
  end

  def roll
    @calculator = Calculator.find(params[:id])
    @calculator.run_scenario(params[:winner], params[:loser], params[:roll_one].to_i, params[:roll_two].to_i)
    @calculator.save

    redirect_to @calculator
  end

  def undo
    @calculator = Calculator.find(params[:id])
    @calculator.undo_roll
    @calculator.save

    redirect_to @calculator
  end

  # def random
  #   @calculator = settings.calculator
  #   @calculator.ranm_scenario(params[:players].to_i, params[:rolls].to_i)

  #   redirect '/calculate'
  # end
end
