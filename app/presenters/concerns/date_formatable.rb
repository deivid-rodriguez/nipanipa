# frozen_string_literal: true

require "active_support/concern"

#
# Common utilities for formatting dates
#
module DateFormatable
  extend ActiveSupport::Concern

  class_methods do
    def relative_time(*attributes)
      attributes.each do |attr|
        define_method(attr) { super() ? relative_time(super()) : never }
      end
    end
  end

  private

  def relative_time(timestamp)
    view.t("shared.timestamp_ago", time: view.time_ago_in_words(timestamp))
  end

  def never
    view.t("shared.never")
  end
end
