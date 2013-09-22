class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
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
    @feedback = current_user.sent_feedbacks.new(feedback_params)
    @feedback.recipient = @user
    authorize! :create, @feedback
    if @feedback.save
      if donation = @feedback.donation
        redirect_to donation.paypal_url(donation_url(donation.id))
      else
        redirect_to @user, notice: t('feedbacks.create.success')
      end
    else
      flash.now[:error] = t('feedbacks.create.error')
      render 'new'
    end
  end

  def index
    @feedback_pairs = Feedback.pairs(@user)
  end

  def edit
   authorize! :edit, @feedback
   @feedback.build_donation if !@feedback.donation
   session[:return_to] = request.referer
  end

  def update
    authorize! :update, @feedback
    if @feedback.update(feedback_params)
      if donation = @feedback.donation
        redirect_to donation.paypal_url(donation_url(donation.id))
      else
        redirect_to session[:return_to], notice: t('feedbacks.update.success')
      end
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

    def feedback_params
      params.require(:feedback).permit(:content, :score, donation_attributes: [:amount, :user_id])
    end

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
