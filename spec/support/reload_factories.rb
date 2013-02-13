# Fixes FactoryGirl crashing inside Devise when using FactoryGirl.reload in
# console
ActionDispatch::Callbacks.after do

  # Reload the factories
  return unless (Rails.env.development? || Rails.env.test?)

  # First init will load factories, this should only run on subsequent reloads
  unless FactoryGirl.factories.blank?
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end
end
