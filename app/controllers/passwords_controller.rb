class PasswordsController < Devise::PasswordsController

  def create
    self.resource =
      resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({},
        location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash.now[:error] = resource.errors.full_messages.first
      respond_with(resource)
    end
  end

end
