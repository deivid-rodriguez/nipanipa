# frozen_string_literal: true

#
# Presentation layer for messages
#
class MessagePresenter < SimpleDelegator
  attr_reader :view

  def initialize(message, view)
    super(message)

    @view = view
  end

  def side(user)
    sender == user ? "left" : "right"
  end
end
