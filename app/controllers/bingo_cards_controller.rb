class BingoCardsController < ApplicationController
  before_action :set_game, only: [:show, :create]

  def index
    @bingo_cards = policy_scope(BingoCard)
  end

  def show
    # raise
    @message = Message.new
    @bingo_card = BingoCard.find(params[:id])
    authorize @bingo_card
    @bingo_tiles = BingoTile.where(bingo_card: @bingo_card)
  end

  def create
    @bingo_card = BingoCard.new
    @bingo_card.game = @game
    @bingo_card.user = current_user
    authorize @bingo_card
    @bingo_card.populate
    if @bingo_card.save
      redirect_to game_bingo_card_path(@game, @bingo_card)
    else
      #TODO kurze Error-Message an User
      redirect_to dashboard_path
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
