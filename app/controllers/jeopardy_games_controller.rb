
class JeopardyGamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:add_category]

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

  def add_category
    @jeopardy_game = JeopardyGame.find(params[:id])
    name = params[:jeopardy_game][:name]
    @jeopardy_game.categories.build(name: name)

    @jeopardy_game.save

    Pusher.trigger('jeopardy', 'update', { data: '' })
    # pusher_update_game

    head :ok
  end

  def update
    @jeopardy_game = JeopardyGame.find(params[:id])
  end

  def show
    @jeopardy_game = JeopardyGame.find(params[:id])

    respond_to do |format|
      format.html do
        render :show
      end
      format.json {
        render json: @jeopardy_game.categories
      }
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


  def pusher_update_game
    Pusher.trigger('jeopardy', 'update', { data: '' })
  end
end
