class CalculatorsController < ApplicationController
  def index
    @calculator = self
  end

  def new
    @calculator = Calculator.new
  end

  def create
    @calculator = Calculator.new(calculator_params)
    if @calculator.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @calculator
    else
      render 'new'
    end
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
