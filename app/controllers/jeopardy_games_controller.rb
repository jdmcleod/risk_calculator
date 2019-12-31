
class JeopardyGamesController < ApplicationController
  skip_before_action :verify_authenticity_token

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

    pusher_update_game

    head :ok
  end

  def remove_category
    @jeopardy_game = JeopardyGame.find(params[:id])
    @jeopardy_game.categories.find(params[:category_id]).destroy
    @jeopardy_game.save

    pusher_update_game

    head :ok
  end

  def add_panel
    @jeopardy_game = JeopardyGame.find(params[:id])
    @category = @jeopardy_game.categories.find(params[:category_id])
    ammount = params[:ammount]
    question = params[:question]
    answer = params[:answer]
    @category.panels.create(ammount: ammount, question: question, answer: answer)
    @category.save
    @jeopardy_game.save

    pusher_update_game

    head :ok
  end

  def edit_panel
    @jeopardy_game = JeopardyGame.find(params[:id])
    @category = @jeopardy_game.categories.find(params[:category_id])
    ammount = params[:ammount]
    question = params[:question]
    answer = params[:answer]

    @category.panels.find(params[:panel_id]).update(ammount: ammount) if ammount != ''
    @category.panels.find(params[:panel_id]).update(question: question) if question != ''
    @category.panels.find(params[:panel_id]).update(question: question) if question != ''
    @category.panels.find(params[:panel_id]).update(answer: answer) if answer != ''

    @category.save
    @jeopardy_game.save

    pusher_update_game

    head :ok
  end

  def remove_panel
    @jeopardy_game = JeopardyGame.find(params[:id])
    @category = @jeopardy_game.categories.find(params[:category_id])
    @category.panels.find(params[:panel_id]).destroy
    @category.save
    @jeopardy_game.save

    pusher_update_game

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
        render json: @jeopardy_game.state[:categories]
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
