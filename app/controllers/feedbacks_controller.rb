class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  before_filter :load_user, only: [:new, :create, :index, :edit, :update]
  before_filter :load_feedback, only: [:edit, :update, :destroy]
  before_filter :set_page_id, only: [:index]

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
      redirect_to @user, notice: t('feedbacks.create.success')
    else
      flash.now[:error] = t('feedbacks.create.error')
      render 'new'
    end
  end

  def index
    authorize! :index, @feedback
    @feedback_pairs = @user.feedback_pairs
  end

  def edit
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
    if @feedback.destroy
      redirect_to current_user, notice: t('feedbacks.destroy.success')
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
