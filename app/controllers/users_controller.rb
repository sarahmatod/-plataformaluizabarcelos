class UsersController < ApplicationController

   def index
      @users = policy_scope(User)
    end

  def show
    authorize User

    @user = User.find(params[:id])
    @votes = @user.user_choices[-1].votes

  end

end
