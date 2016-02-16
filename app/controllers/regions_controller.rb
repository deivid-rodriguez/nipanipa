# frozen_string_literal: true

#
# Handles Region Select Box behaviour
#
class RegionsController < ApplicationController
  respond_to :json

  def index
    @regions = Region.where(country_id: params[:country_id])

    respond_with(@regions)
  end
end
