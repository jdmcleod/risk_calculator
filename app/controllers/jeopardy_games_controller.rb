
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

  def add_team
    @jeopardy_game = JeopardyGame.find(params[:id])
    name = params[:jeopardy_game][:name]
    @jeopardy_game.teams.build(name: name, score: 0)

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

  def remove_team
    @jeopardy_game = JeopardyGame.find(params[:id])
    @jeopardy_game.teams.find(params[:team_id]).destroy
    @jeopardy_game.save

    pusher_update_game

    head :ok
  end

  def add_score
    @jeopardy_game = JeopardyGame.find(params[:id])
    team = @jeopardy_game.teams.find(params[:team_id])
    team.update(score: team.score += params[:ammount].to_i)
    @jeopardy_game.categories.find(params[:category_id]).panels.find(params[:panel_id]).update(completed: true) if params[:category_id]
    @jeopardy_game.save
    pusher_update_game

    head :ok
  end

  def no_answer
    @jeopardy_game = JeopardyGame.find(params[:id])
    @jeopardy_game.categories.find(params[:category_id]).panels.find(params[:panel_id]).update(completed: true)
    @jeopardy_game.save
    pusher_update_game

    head :ok
  end

  def reset_panels
    @jeopardy_game = JeopardyGame.find(params[:id])
    @jeopardy_game.categories.each do |category|
      category.panels.each do |panel|
        panel.update(completed: false)
      end
    end

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
    @category.panels.create(ammount: ammount, question: question, answer: answer, completed: false)
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
        render json: { categories: @jeopardy_game.state[:categories],
                       teams: @jeopardy_game.teams }
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
