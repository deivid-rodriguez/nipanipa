class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Openwwoof!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.new
  end

end
