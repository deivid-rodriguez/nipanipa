ActiveSupport::Notifications.subscribe /factory_girl/ do |name, start, finish, id, payload|
  Rails.logger.debug( ["notifications: ", name, start, finish, id, payload].join(" ") )
end
