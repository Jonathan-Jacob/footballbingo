class ChatroomsController < ApplicationController
  def show
    @game = Game.find(params)[:game_id]
    @group = Group.find(params[:group_id])
    @chatroom = Chatroom.find(params[:id])
  end
end
