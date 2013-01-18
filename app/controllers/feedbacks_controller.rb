class FeedbacksController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy]
  before_filter :not_same_user , only: [:new, :create]
  before_filter :same_user     , only: [:destroy]

  def new
    @feedback = @recipient.received_feedbacks.new
  end

  def create
    @feedback = @recipient.received_feedbacks.new(params[:feedback])
    @feedback.sender = @current_user
    if @feedback.save
      flash[:success] = "Feedback created!"
      redirect_to @recipient
    else
      flash.now[:error] = "You already gave feedback to that user"
      render 'new'
    end
  end

  def destroy
    @feedback = @sender.sent_feedbacks.find([:id])
    @feedback.destroy
    flash[:sucess] = "Feedback destroyed"
    redirect_to @sender
  end

  private

    def same_user
      @sender = User.find(params[:user_id])
      redirect_to root_path unless current_user?(@sender)
    end

    def not_same_user
      @recipient = User.find(params[:user_id])
      redirect_to root_path unless !current_user?(@recipient)
    end

end
