class UsersController < Devise::RegistrationsController
  load_and_authorize_resource

  def new
    super
    @user.language_skills.build(language: Language.find_by(code: 'en'),
                                level: :expert)
  end

  def index
    @users = resource_class
    if params[:availability] == 'now'
      @users = @users.currently_available
    end
    @users = @users.order('last_sign_in_at DESC').paginate(page: params[:page])
  end

  def show
    @page_id = :general
    @user = User.find(params[:id])
    @given_feedback = user_signed_in? ?
      Feedback.find_by(sender: current_user, recipient: @user) : nil
    @feedback_pairs = Feedback.pairs(@user)
  end

  def edit
    @user = current_user
    @page_id = :edit
  end

  private

    # Override redirect after profile edition
    def after_update_path_for(resource)
      resource
    end

    # Override redirect after signup
    def after_sign_up_path_for(resource)
      resource
    end

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
      params.require(:user).permit(
        :accomodation, :description, :email, :name, :password,
        :password_confirmation, :skills, availability: [],
        language_skills_attributes: [:language_id, :level, :_destroy],
        work_type_ids: [])

    end

    def volunteer_params
      params.require(:user).permit(
        :description, :email, :name, :password, :password_confirmation, :skills,
        availability: [],
        language_skills_attributes: [:language_id, :level, :_destroy],
        work_type_ids: [])
    end

    # Correctly resolve actual class from params
    def resource_class
      params[:type].present? ? params[:type].classify.constantize : super
    end

    # Use a single devise mapping for both classes
    def devise_mapping
      Devise.mappings[:user]
    end
end
