class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :destroy]

  def new
    @user = User.find(params[:user_id])
    @feedback = current_user.sent_feedbacks.new
    @feedback.recipient = @user
    authorize! :new, @feedback
  end

  def create
    @user = User.find(params[:user_id])
    @feedback = current_user.sent_feedbacks.new(params[:feedback])
    @feedback.recipient = @user
    authorize! :create, @feedback
    if @feedback.save
      redirect_to @user, notice: t('feedbacks.new.flash_notice')
    else
      flash.now[:error] = "You already gave feedback to that user"
      render 'new'
    end
  end

  def destroy
    @feedback = @sender.sent_feedbacks.find([:id])
    @feedback.destroy
    redirect_to @sender, notice: t('feedbacks.destroy.flash_notice')
  end

end
