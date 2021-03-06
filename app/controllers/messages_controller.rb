class MessagesController < ApplicationController

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @bingo_card = BingoCard.find_by(user: current_user, game: @chatroom.game )
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    authorize @message
    if @message.chatroom.game.nil?
      if @message.save
        ChatroomChannel.broadcast_to(
          @chatroom,
          render_to_string(partial: "message", locals: { message: @message })
        )
      else
        render "groups/show"
      end
    else
      if @message.save
        ChatroomChannel.broadcast_to(
          @chatroom,
          render_to_string(partial: "message", locals: { message: @message })
        )
      else
        render "bingo_cards/show"
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
