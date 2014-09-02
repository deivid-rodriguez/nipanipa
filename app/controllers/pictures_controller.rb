class PicturesController < ApplicationController
  before_action :load_user, only: [:index]
  before_action :load_picture, only: [:edit, :update, :destroy]

  def new
    @picture = current_user.pictures.build
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    if @picture.save
      redirect_to user_pictures_path(current_user),
                  notice: t('pictures.create.success')
    else
      flash.now[:error] = t('pictures.create.error')
      render 'new'
    end
  end

  def index
    @page_id = :pictures
    @pictures = @user.pictures
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      redirect_to user_pictures_path(current_user),
                  notice: t('pictures.update.success')
    else
      flash.now[:error] = t('pictures.update.error')
      render 'edit'
    end
  end

  def destroy
    if @picture.destroy
      redirect_to user_pictures_path(current_user),
                  notice: t('pictures.destroy.success')
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:image, :image_cache, :name, :user_id)
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_picture
    @picture = current_user.pictures.find(params[:id])
  end
end
