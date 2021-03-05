class BingoCardsController < ApplicationController
  before_action :set_game, only: [:show, :create]

  def index
    @bingo_cards = policy_scope(BingoCard)
  end
  def show
    @bingo_card = BingoCard.find(params[:id])
    authorize @bingo_card
  end

  def create
    # raise
    # if @game.bingo_cards.each do |bingo_card|
    #   redirect_to game_bingo_cards_path(@game, bingo_card) if bingo_card.user == current_user
    #   end
    # else
      @bingo_card = BingoCard.new
      @bingo_card.game = @game
      @bingo_card.user = current_user
      authorize @bingo_card
      if @bingo_card.save
        redirect_to game_bingo_card_path(@game, @bingo_card)
      else
        redirect_to dashboard_path
      end
    # end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
