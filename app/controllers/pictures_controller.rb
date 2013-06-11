class PicturesController < ApplicationController
  before_filter :load_user, only: [:index]

  def index
    @page_id = :pictures
    @pictures = @user.pictures
  end

  private

    def load_user
      @user = User.find(params[:user_id])
    end
end
