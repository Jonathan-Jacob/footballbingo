class ChatroomsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @chatroom = Chatroom.find(params[:id])
  end
end
