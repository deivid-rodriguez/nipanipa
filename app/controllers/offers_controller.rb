class OffersController < ApplicationController

  def new
    @offer = current_user.offers.new
  end

  def create
    @offer = current_user.offers.new(params[:offer])
    if @offer.save
      redirect_to current_user, notice: t('offers.create.success')
    else
      flash.now[:error] = t('offers.create.error')
      render 'new'
    end
  end

  def show
  end

  def index
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
