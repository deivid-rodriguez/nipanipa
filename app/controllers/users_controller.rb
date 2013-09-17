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
      Feedback.find_by(sender: current_user, recipient: @user) : nil
    @feedback_pairs = @user.feedback_pairs
  end

  def edit
    @user = current_user
    @page_id = :edit
  end

  private

    # Override devise default of asking password for updates
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    # Override devise parameter sanitization
    def sign_up_params
      user_params
    end

    def account_update_params
      user_params
    end

    def user_params
      send("#{resource_class.to_s.downcase}_params")
    end

    def host_params
      params.require(:user)
            .permit(:accomodation, :description, :email, :name, :password,
                    :password_confirmation, :skills, work_type_ids: [])
    end

    def volunteer_params
      params.require(:user)
            .permit(:description, :email, :name, :password,
                    :password_confirmation, :skills, work_type_ids: [])
    end

    def resource_class
      params[:type].present? ? params[:type].classify.constantize : super
    end
end
