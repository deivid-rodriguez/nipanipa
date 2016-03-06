# frozen_string_literal: true

#
# Base presentation layer
#
class ApplicationPresenter < SimpleDelegator
  attr_reader :view

  def initialize(object, view)
    super(object)

    @view = view
  end
end
