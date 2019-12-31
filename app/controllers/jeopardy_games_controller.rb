
class JeopardyGamesController < ApplicationController
  def index
    @jeopardy_game = self
  end

  def show
    @jeopardy_game = Jeopardy.find(params[:id])
    @roll = @jeopardy_game.rolls.build
  end

  def new
    @jeopardy_game = JeopardyGame.new
  end

  def create
    @jeopardy_game = JeopardyGame.new(name: params[:name], user: current_user)
    if @jeopardy_game.save
      flash[:success] = "Game created"
      redirect_to @jeopardy_games
    else
      flash[:danger] = "Error"
      render 'new'
    end
  end

end
