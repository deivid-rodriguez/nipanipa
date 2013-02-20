class DonationsController < ApplicationController
  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.new(params[:donation])
    if @donation.save
      redirect_to @donation.paypal_url(donation_url(@donation.id))
    else
      render :action => 'new'
    end
  end

  def show
    @donation = Donation.find(params[:id])

    response = Donation.send_pdt_post(params[:tx])

    if response.body.lines.first.chomp == 'SUCCESS'
      flash.now[:notice] = t('donations.new.flash_success')
    else
      flash.now[:alert] = t('donations.new.flash_error')
    end
    render 'static_pages/home'
  end

  # We don't activate IPN for now
  # Check railcast #142 to implement it
  # def notify
  # end

end
