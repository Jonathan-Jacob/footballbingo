class GamesController < ApplicationController
  before_action :set_game, only: [:show, :join_game]
  before_action :set_group, only: [:new, :create]

  def index
    @games = policy_scope(Game)
  end

  # all group games / all user names

  def show
    authorize @game
  end

  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    @game.group = @group
    # @bingo_card = BingoCard.new(user: current_user, game: @game)
    # authorize @bingo_card
    if @game.save
      redirect_to group_path(@group)
    else
      render 'new'
    end
  # connection to group
  end

  def join_game
    # edit
    @bingo_card = BingoCard.new(user: current_user, game: @game)
    authorize @bingo_card
    if @bingo_card.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  private

  def game_params
    params.require(:game).permit(:match_id)
  end

  def set_game
    @game = Game.find(params[:id])
  end

   def set_group
    @group = Group.find(params[:group_id])
  end
end
