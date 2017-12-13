# frozen_string_literal: true

#
# Main controller for all users (hosts and volunteers)
#
class UsersController < Devise::RegistrationsController
  before_action :authenticate_user!, only: %i[edit update delete]

  def new
    super do |resource|
      resource.region = Country.default.regions.default

      language = Language.find_by(code: I18n.locale)
      break unless language

      resource.language_skills.build(language: language, level: :expert)
    end
  end

  def index
    @users = apply_filters.by_latest_sign_in.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @feedback_pairs = Feedback.pairs(@user)
  end

  def edit
    @user = current_user
  end

  def update
    super
  end

  def delete
  end

  private

  def apply_filters
    users = filter_class.confirmed
    users = users.currently_available if params[:availability].nil?
    users = users.from_continent(continent_id.to_i) if continent_id
    users = users.from_country(country_id.to_i) if country_id
    users
  end

  def country_id
    params[:cou_id]
  end

  def continent_id
    params[:con_id]
  end

  #
  # Override devise redirections
  #
  def after_update_path_for(resource)
    resource
  end

  def after_inactive_sign_up_path_for(_resource)
    new_user_session_path
  end

  def after_sign_out_path_for(_resource)
    users_path
  end

  #
  # Override devise default of asking password for updates
  #
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def proper_fields
    %i[description email name password password_confirmation region_id skills]
  end

  def nested_fields
    [
      availability: [],
      work_type_ids: [],
      language_skills_attributes: %i[id language_id level _destroy]
    ]
  end

  def user_fields
    proper_fields + nested_fields
  end

  def host_params
    [:accommodation, *user_fields]
  end

  def volunteer_params
    user_fields
  end

  #
  # Correctly resolve actual class from params
  #
  def resource_class
    params[:type] ? detected_class_from(params[:type]) : User
  end

  def resource_class_from_params
    params[:type] ? detected_class_from(params[:type]) : nil
  end

  def resource_class_from_current_user
    return User unless current_user

    current_user.is_a?(Host) ? Volunteer : Host
  end

  def filter_class
    resource_class_from_params || resource_class_from_current_user
  end
  helper_method :filter_class

  #
  # Use a single devise mapping for both classes
  #
  def devise_mapping
    Devise.mappings[:user]
  end

  def detected_class_from(type)
    [Volunteer, Host, User].find { |klass| klass.name == type.classify }
  end
end
