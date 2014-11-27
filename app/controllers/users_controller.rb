#
# Main controller for all users (hosts and volunteers)
#
class UsersController < Devise::RegistrationsController
  load_and_authorize_resource

  def new
    super do |resource|
      resource.region = Country.default.regions.default

      language = Language.find_by(code: I18n.locale)
      break unless language

      resource.language_skills.build(language: language, level: :expert)
    end
  end

  def index
    users = resource_class
    users = users.currently_available if params[:availability] == 'now'
    users = users.from_continent(params[:con_id].to_i) if params[:con_id]
    users = users.from_country(params[:cou_id].to_i) if params[:cou_id]
    @users = users.by_latest_sign_in.page(params[:page])
  end

  def show
    @page_id = :general
    @user = User.find(params[:id])
    @given_feedback = Feedback.find_by(sender: current_user, recipient: @user)
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
    [
      :description,
      :email,
      :name,
      :password,
      :password_confirmation,
      :region_id,
      :skills,
      availability: [],
      work_type_ids: [],
      language_skills_attributes: [:id, :language_id, :level, :_destroy]
    ]
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
