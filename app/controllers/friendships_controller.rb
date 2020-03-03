class FriendshipsController < ApplicationController
  def create
    current_user.friendships.build(friend_id: params[:friend])
    if(current_user.save)
      flash[:notice] = "Following user"
    else
      flash[:alert] = "Something went wrong with the tracking request"
    end
    redirect_to friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Stopped following"
    redirect_to friends_path
  end
end
