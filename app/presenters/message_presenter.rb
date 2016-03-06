# frozen_string_literal: true

#
# Presentation layer for messages
#
class MessagePresenter < ApplicationPresenter
  def side(user)
    sender == user ? "left" : "right"
  end
end
