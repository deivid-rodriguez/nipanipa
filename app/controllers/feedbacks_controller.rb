class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  before_filter :load_user, only: [:new, :create, :edit, :update]
  before_filter :load_feedback, only: [:edit, :update]

  def new
    @feedback = current_user.sent_feedbacks.new
    @feedback.recipient = @user
    authorize! :new, @feedback
  end

  def create
    @feedback = current_user.sent_feedbacks.new(params[:feedback])
    @feedback.recipient = @user
    authorize! :create, @feedback
    if @feedback.save
      redirect_to @user, notice: t('feedbacks.create.flash_notice')
    else
      flash.now[:error] = t('feedbacks.create.flash_error')
      render 'new'
    end
  end

  def edit
   authorize! :edit, @feedback
  end

  def update
   authorize! :update, @feedback
    if @feedback.update_attributes(params[:feedback])
      redirect_to current_user, notice: t('feedbacks.update.flash_notice')
    else
      flash.now[:error] = t('feedbacks.update.flash_error')
      render 'edit'
    end
  end

  def destroy
    @feedback = @sender.sent_feedbacks.find([:id])
    @feedback.destroy
    redirect_to @sender, notice: t('feedbacks.destroy.flash_notice')
  end

  private

    def load_user
      @user = User.find(params[:user_id])
    end

    def load_feedback
      @feedback = current_user.sent_feedbacks.find(params[:id])
    end

end
