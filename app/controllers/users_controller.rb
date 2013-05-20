class UsersController < Devise::RegistrationsController

  def index
    @users = resource_class.order('last_sign_in_at DESC').
                            paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @no_feedback_link = dont_leave_feedback?(@user)
    @feedback_pairs = @user.feedback_pairs
  end

  # Override default devise update action to allow blank password (meaning no
  # change)
  def update
    remove_blank_password_from_params

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true # bypass validation in case passw changed
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  protected

    def after_update_path_for(resource)
      user_path(resource)
    end

  private

    def dont_leave_feedback?(user)
      user_signed_in? &&
      ( current_user == @user ||
        Feedback.find_by_sender_id_and_recipient_id(current_user.id, @user.id) )
    end

    def resource_class
      params[:type].present? ? params[:type].classify.constantize : super
    end

    def remove_blank_password_from_params
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
    end

end
