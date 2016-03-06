# frozen_string_literal: true

require "concerns/date_formatable"

#
# Presentation layer for listing profile summaries
#
class ProfileSummaryPresenter < ApplicationPresenter
  include DateFormatable

  relative_time :last_sign_in_at
end
