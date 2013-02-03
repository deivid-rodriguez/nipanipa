class UsersController < ApplicationController
  layout 'user_new', only: [:new, :create]

  before_filter :signed_in_user,     only: [:index, :edit, :update, :destroy]
  before_filter :same_user,          only: [:edit, :update]
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :admin_user,         only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @received_feedbacks = @user.received_feedbacks.paginate(page: params[:page])
  end

  def create
    @user = user_type.new(params[:user])
    @user.location = Location.where(address: params[:location]).first_or_create
    if @user.save
      sign_in @user
      redirect_to @user, flash: { success: t('users.new.flash_success') }
    else
      render 'new'
    end
  end

  def new
    @user = user_type.new
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user, flash: { success: t('users.edit.flash_success') }
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: t('users.destroy.flash_notice')
  end

  private

    def user_type
      params[:type].camelize.constantize
    end

    def not_signed_in_user
      redirect_to(root_path) unless !signed_in?
    end

    def same_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user.admin? && !current_user?(@user)
    end

end
