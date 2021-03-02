class GamesController < ApplicationController

  def index
    @games = Game.where(user_id: current_user).order(created_at: :desc)
  end

  # all group games / all user names


  def show
    @game = Game.find(params[:id])
    authorize @game
  end

   def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    @game.user = current_user
    if @game.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  # connection to group
  end

  def join
    @game = Game.find(params[:id])
    @game.us = params[:booking][:status]
    @treehouse = @booking.treehouse
    @booking.save
    authorize @game
    redirect_to game_path(@game)
  end


end


 private

  def game_params
    params.require(:game).permit(:match_id, group_id )
  end
