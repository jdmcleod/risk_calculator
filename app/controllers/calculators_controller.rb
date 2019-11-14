class CalculatorsController < ApplicationController
  def index
    @calculator = self
  end

  def new
    @calculator = Calculator.new
  end

  def show
    @calculator = Calculator.find(params[:id])
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
    @calculator.find_or_add_player(params[:calculator][:player_name])
    @calculator.save

    redirect_to @calculator
  end

  def remove_player
    @calculator = Calculator.find(params[:id])
    @calculator.players.find_by(name: params[:name]).destroy
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

  def load

  end

  # def new_player
  #   name = params[:new_name]
  #   @calculator = settings.calculator

  #   if name && name != ''
  #     @calculator.find_or_add_player(name)
  #   end

  #   redirect '/calculate'
  # end

  # def roll
  #   @calculator = Calculator.find(params[:id])
  #   @calculator.run_scenario(params[:winner], params[:loser], params[:roll_one].to_i, params[:roll_two].to_i)

  #   redirect '/calculate'
  # end

  # def undo-roll
  #   @calculator = settings.calculator
  #   @calculator.undo_roll

  #   redirect '/calculate'
  # end

  # def random
  #   @calculator = settings.calculator
  #   @calculator.ranm_scenario(params[:players].to_i, params[:rolls].to_i)

  #   redirect '/calculate'
  # end
end
