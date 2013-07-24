class UsersController < Devise::RegistrationsController
  def new
    @user = resource_class.new
  end

  def index
    @users = resource_class.order('last_sign_in_at DESC').
                            paginate(page: params[:page])
  end

  def show
    @page_id = :general
    @user = User.find(params[:id])
    @given_feedback = user_signed_in? ?
      Feedback.find_by_sender_id_and_recipient_id(current_user.id, @user.id) :
      nil
    @feedback_pairs = @user.feedback_pairs
  end

  def edit
    @user = current_user
    @page_id = :edit
  end

  # Override default devise update action to allow blank password (meaning no
  # change)
  def update
    @page_id = :edit
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

    def resource_class
      params[:type].present? ? params[:type].classify.constantize : super
    end

    def devise_mapping
      Devise.mappings[:user]
    end

    def remove_blank_password_from_params
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
    end
end
