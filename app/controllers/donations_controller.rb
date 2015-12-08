#
# Controller for donations functionality
#
class DonationsController < ApplicationController
  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.new(donation_params)
    if @donation.save
      redirect_to @donation.paypal_url(donation_url(@donation.id))
    else
      render action: 'new'
    end
  end

  def show
    @donation = Donation.find(params[:id])
    resp = Donation.send_pdt_post(params[:tx])

    redirect_to return_path, flash_message(resp)
  end

  # We don't activate IPN for now
  # Check railcast #142 to implement it
  # def notify
  # end

  private

  def flash_message(resp)
    if resp.body.lines.first.chomp == 'SUCCESS'
      { notice: t('donations.create.success') }
    else
      { alert: t('donations.create.error') }
    end
  end

  def return_path
    session[:return_to] || @donation.user || root_path
  end

  def donation_params
    params.require(:donation).permit(:amount, :feedback_id, :user_id)
  end
end
