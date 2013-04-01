class ConversationsController < ApplicationController
  respond_to :html, :js

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
  end

  def new
    @conversation = Conversation.new(offer_id: params[:offer],
                                     to_id: params[:to])
    @conversation.messages.build
  end

  def create
    @conversation = Conversation.new(params[:conversation].merge(
      to_id: params[:conversation][:messages_attributes]["0"][:to_id],
      from_id: params[:conversation][:messages_attributes]["0"][:from_id]))
    if @conversation.save
      redirect_to current_user, notice: t('conversations.create.success')
    else
      flash.now[:error] = t('conversations.create.error')
      render :action => 'new'
    end
  end

  def reply
    @conversation = Conversation.find(params[:id])
    @conversation.messages.build(body: params[:body], from_id: current_user.id,
      to_id: @conversation.to == current_user ?
             @conversation.from.id : @conversation.to.id )
    if @conversation.save
      respond_to do |format|
        format.html { redirect_to user_conversations current_user }
        format.js
      end
    else
      render 'show'
    end
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy
    redirect_to conversations_url, :notice => "Successfully destroyed conversation."
  end
end
