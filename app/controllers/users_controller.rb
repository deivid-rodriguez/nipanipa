class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
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
