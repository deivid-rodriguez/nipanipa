# Fix crash inside Devise when using FactoryGirl.reload in console
ActionDispatch::Reloader.to_cleanup do
  return unless Rails.env.development?

  unless FactoryGirl.factories.blank?
    FactoryGirl.factories.clear
    FactoryGirl.traits.clear
    FactoryGirl.find_definitions
  end
end
