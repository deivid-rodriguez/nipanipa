# frozen_string_literal: true

notifier = ActiveSupport::Notifications

notifier.subscribe(/!factory_girl/) do |name, start, finish, id, payload|
  Rails.logger.debug(
    ["notifications: ", name, start, finish, id, payload].join(" "))
end

# ActiveSupport::Notifications.subscribe /!render_template.action_view/  do
#  |name, start, finish, id, payload|
#    Rails.logger.debug(
#      ['notifications: ', name, start, finish, id, payload].join(' '))
# end
