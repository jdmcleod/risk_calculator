
class JeopardyGamesController < ApplicationController
  def index
    @jeopardy_game = self
  end

  def show
    @jeopardy_game = JeopardyGame.find(params[:id])
  end

  def new
    @jeopardy_game = JeopardyGame.new
  end

  def create
    @jeopardy_game = JeopardyGame.new(name: params[:jeopardy_game][:name], user: current_user)
    if @jeopardy_game.save
      flash[:success] = "Game created"
      render :index
    else
      flash[:danger] = "Error"
      render 'new'
    end
  end

  def destroy
    @jeopardy_game = JeopardyGame.find(params[:id])
    if @jeopardy_game.destroy
      redirect_to jeopardy_games_path, flash: { success: "#{@jeopardy_game.name} deleted" }
    else
      render :index, flash: { error: "#{@jeopardy_game.name} could not be deleted" }
    end
  end
end
