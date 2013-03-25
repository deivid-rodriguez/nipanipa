class ConversationsController < ApplicationController

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def new
    @conversation = Conversation.new(offer_id: params[:offer],
                                     to_id: params[:to])
    @conversation.messages.build
  end

  def create
    #@offer = Offer.find(params[:id])
    #@offer.candidates << current_user
    #OfferMailer.new_subscription(@offer.host, current_user)
    #redirect_to current_user, notice: t('offers.subscription.success')
    @conversation = Conversation.new(params[:conversation])
    if @conversation.save
      redirect_to current_user, notice: t('conversations.create.success')
    else
      render :action => 'new'
    end
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy
    redirect_to conversations_url, :notice => "Successfully destroyed conversation."
  end
end
