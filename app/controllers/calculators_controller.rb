class CalculatorsController < ApplicationController
  def index
  end

  def calculate
  end

  get '/calculate' do
    @calculator = settings.calculator

    slim :index
  end

  get '/' do
    slim :info
  end

  get '/csv' do
    @calculator = settings.calculator
    content_type 'application/csv'
    attachment "#{params[:name]}.csv"
    CSV.generate do |csv|
      @calculator.rolls.each do |roll|
        csv << [roll.player1.name, roll.player2.name, roll.die1, roll.die2]
      end
    end
  end

  get '/load' do
    slim :load
  end

  get '/save' do
    slim :save
  end

  post '/load' do
    @calculator = settings.calculator
    content = params['file'][:tempfile].read
    content_arr = []
    content.each_line do |line|
        content_arr << [line]
    end
    @calculator.load_game(content_arr)
    redirect '/calculate'
  end

  post '/new_player' do
    name = params[:new_name]
    @calculator = settings.calculator

    if name && name != ''
      @calculator.find_or_add_player(name)
    end

    redirect '/calculate'
  end

  post '/roll' do
    @calculator = settings.calculator
    @calculator.run_scenario(params[:winner], params[:loser], params[:roll_one].to_i, params[:roll_two].to_i)

    redirect '/calculate'
  end

  post '/undo-roll' do
    @calculator = settings.calculator
    @calculator.undo_roll

    redirect '/calculate'
  end

  post '/random' do
    @calculator = settings.calculator
    @calculator.random_scenario(params[:players].to_i, params[:rolls].to_i)

    redirect '/calculate'
  end

  post '/clear' do
    @calculator = settings.calculator
    @calculator.clear()

    redirect '/calculate'
  end
end
end
