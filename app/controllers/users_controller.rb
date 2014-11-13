#
# Main controller for all users (hosts and volunteers)
#
class UsersController < Devise::RegistrationsController
  load_and_authorize_resource

  def new
    build_resource({})
    current_language = Language.find_by(code: I18n.locale)
    resource.language_skills.build(language: current_language, level: :expert)
    respond_with resource
  end

  def index
    users = resource_class
    users = users.currently_available if params[:availability] == 'now'
    users = users.from_continent(params[:con_id].to_i) if params[:con_id]
    users = users.from_country(params[:cou_id].to_i) if params[:cou_id]
    @users = users.order('last_sign_in_at DESC').page(params[:page])
  end

  def show
    @page_id = :general
    @user = User.find(params[:id])
    if user_signed_in?
      @given_feedback = Feedback.find_by sender: current_user, recipient: @user
    end
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

  def user_fields
    [:description, :email, :name, :password, :password_confirmation, :skills,
     availability: [], work_type_ids: [],
     language_skills_attributes: [:id, :language_id, :level, :_destroy]]
  end

  def host_params
    params.require(:user).permit(:acommodation, *user_fields)
  end

  def volunteer_params
    params.require(:user).permit(*user_fields)
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
