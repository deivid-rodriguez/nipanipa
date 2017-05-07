# frozen_string_literal: true

#
# Presentation layer for listing profile summaries
#
class ProfileSummaryPresenter < ApplicationPresenter
  include DateFormatable

  relative_time :last_sign_in_at
end
