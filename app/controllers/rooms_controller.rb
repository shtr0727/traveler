class RoomsController < ApplicationController

  def create
    # ルームのインスタンスを作成
    @room = Room.create
    # 作成したルーム（親要素）に紐づくエントリー（子要素）のインスタンスを作成（アソシエーションを活用）
    @current_entry = @room.entries.create(room_id: current_user.id)
    @another_entry = @room.entries.create(user_id: params[:entry][:user_id])
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id]) # １つのルームを表示
    if @room.entries.where(user_id: current_user.id).exists? # 自分が相手ユーザーと既にチャットルームにエントリーしているかを確認
      @messages = @room.messages.all
      @message = Message.new
      @entries = @room.entries
      @another_entry = @entries.where.not(user_id: current_user.id).first # ルームに参加している２名のうち、相手ユーザーのエントリーを取得
    else
      redirect_back(fallback_location: root_path)
    end
  end

end
