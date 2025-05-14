class RoomsController < ApplicationController

  def create
    # ルームのインスタンスを作成
    @room = Room.create
    # 作成したルーム（親要素）に紐づくエントリー（子要素）のインスタンスを作成（アソシエーションを活用）
    @current_entry = @room.entries.create(room_id: current_user.id)
    @another_entry = @room.entries.create(user_id: params[:entry][user_id])
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if @room.entries.where(user_id: current_user.id).exists?
      @messages = @room.messages.all
      @message = Message.new
      @entries = @room.entries
      @another_entry = @entries.find_by.not(user_id: current_user.id).first
    else
      redirect_back(fallback_location: root_path)
    end
  end

end
