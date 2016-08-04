class FriendsController < ApplicationController
  def update
    @user = User.find(params[:id])
    current_user.add_friend(@user)
    flash[:notice] = '添加好友成功!'
    redirect_back fallback_location: root_path
  end

  def destroy
    @user = User.find(params[:id])
    current_user.remove_friend(@user)
    flash[:notice] = '删除好友成功!'
    redirect_back fallback_location: root_path
  end
end
