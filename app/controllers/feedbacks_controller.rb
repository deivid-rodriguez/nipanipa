class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  before_filter :load_user, only: [:new, :create, :index, :edit, :update]
  before_filter :load_feedback, only: [:edit, :update, :destroy]
  before_filter :set_page_id, only: [:index]

  def new
    @feedback = current_user.sent_feedbacks.new
    @feedback.recipient = @user
    @feedback.build_donation
    authorize! :new, @feedback
  end

  def create
    @feedback = current_user.sent_feedbacks.new(params[:feedback])
    @feedback.recipient = @user
    authorize! :create, @feedback
    if @feedback.save
      # To detect whether we are coming from a feedback in donations controller
      session[:from_feedback] = true
      if @feedback.donation
        redirect_to \
          @feedback.donation.paypal_url(donation_url(@feedback.donation.id)),
          notice: t('feedbacks.create.success')
      else
        redirect_to @user, notice: t('feedbacks.create.success')
      end
    else
      flash.now[:error] = t('feedbacks.create.error')
      render 'new'
    end
  end

  def index
    @feedback_pairs = @user.feedback_pairs
  end

  def edit
   @feedback.build_donation if !@feedback.donation
   authorize! :edit, @feedback
  end

  def update
   authorize! :update, @feedback
    if @feedback.update_attributes(params[:feedback])
      redirect_to current_user, notice: t('feedbacks.update.success')
    else
      flash.now[:error] = t('feedbacks.update.error')
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @feedback
    flash.now[:notice] = t('feedbacks.destroy.success')
    if @feedback.destroy
      redirect_to :back, notice: t('feedbacks.destroy.success')
    end
  end

  private

    def load_user
      @user = User.find(params[:user_id])
    end

    def load_feedback
      @feedback = current_user.sent_feedbacks.find(params[:id])
    end

    def set_page_id
      @page_id = :feedback
    end
end
