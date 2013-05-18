class PasswordsController < Devise::PasswordsController
  after_filter :flash_errors

  # Just show first error of first attribute
  def flash_errors
    unless resource.errors.empty?
      flash[:error] = resource.errors.messages.values.first.first
    end
  end
end
