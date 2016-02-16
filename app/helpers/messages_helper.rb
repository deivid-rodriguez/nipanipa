# frozen_string_literal: true

#
# Various utilites for message pages
#
module MessagesHelper
  def side(message)
    message.sender == current_user ? 'left' : 'right'
  end
end
