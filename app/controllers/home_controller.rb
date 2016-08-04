class HomeController < ApplicationController
  def index
  end

  def users
    @users = User.where.not(id: current_user.id)
  end
end
