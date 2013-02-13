class UsersController < Devise::RegistrationsController
  layout 'user_new', only: [:new, :create]

  before_filter :geolocate_ip, only: [:index, :show]

  def new
    @user = params[:type].classify.constantize.new
  end

  def create
    @user = params[:type].classify.constantize.new(params[:user])
    @user.location = Location.where(address: params[:location]).first_or_create
    if @user.save
      sign_up @user, force: true
      redirect_to @user, notice: t('users.create.flash_notice')
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @no_feedback_link = dont_leave_feedback?(@user)
    @received_feedbacks = @user.received_feedbacks.paginate(page: params[:page])
  end

  def edit
    super
  end

  def update
    # Blank password allow (doesn't change)
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user), notice: t('users.update.flash_notice')
    else
      render 'edit'
    end
  end

  def destroy
    super
  end

  protected

    def after_update_path_for(resource)
      user_path(resource)
    end

  private

    def geolocate_ip
      @last_location = "#{request.location.state} (#{request.location.country})"
    end

    def dont_leave_feedback?(user)
      user_signed_in? &&
      ( current_user == @user ||
        Feedback.find_by_sender_id_and_recipient_id(current_user.id, @user.id) )
    end

end
