# frozen_string_literal: true

#
# Controller for feedback functionality
#
class FeedbacksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_user, only: [:new, :create, :index, :edit, :update]
  before_action :load_feedback, only: [:edit, :update, :destroy]

  def new
    @feedback = current_user.sent_feedbacks.new

    @feedback.build_donation
    session[:return_to] = request.referer
    authorize! :new, @feedback
  end

  def create
    @feedback = current_user.sent_feedbacks.new(feedback_params)
    authorize! :create, @feedback

    if @feedback.save
      donate_or_redirect(@feedback.donation, :create)
    else
      flash.now[:error] = t("feedbacks.create.error")
      render "new"
    end
  end

  def index
    @feedback_pairs = Feedback.pairs(@user)
  end

  def edit
    authorize! :edit, @feedback
    @feedback.build_donation unless @feedback.donation
    session[:return_to] = request.referer
  end

  def update
    authorize! :update, @feedback

    if @feedback.update(feedback_params)
      donate_or_redirect(@feedback.donation, :update)
    else
      flash.now[:error] = t("feedbacks.update.error")
      render "edit"
    end
  end

  def destroy
    authorize! :destroy, @feedback
    flash.now[:notice] = t("feedbacks.destroy.success")
    return unless @feedback.destroy

    redirect_to :back, notice: t("feedbacks.destroy.success")
  end

  private

  def donate_or_redirect(donation, action)
    if donation
      redirect_to donation.paypal_url(donation_url(donation.id))
    else
      redirect_to session[:return_to], notice: t("feedbacks.#{action}.success")
    end
  end

  def feedback_params
    params.require(:feedback).permit(:content,
                                     :score,
                                     :recipient_id,
                                     donation_attributes: [:amount, :user_id])
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_feedback
    @feedback = current_user.sent_feedbacks.find(params[:id])
  end
end
