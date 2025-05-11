class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user

    # 現在ログインしているユーザー（自分）をEntriseテーブルから取得する。
    @current_entry = Entry.where(user_id: current_user.id)
    # メッセージ相手になるユーザーEntriseテーブルから取得する。
    @another_entry = Entry.where(user_id: @user.id)
    # 相手が自分自身ではなく、相互フォローしている場合のみDM処理を許可。
    if @user.id != current_user.id && current_user.mutual_follow?(@user)
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id # each doで取り出されたcurrentとanotherが一致する場合は
            @is_room = true # 自分と相手が同じroomに存在しているフラグ
            @room_id = current.room_id # 現在のroom idをインスタンス変数として扱いビューに渡す
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
