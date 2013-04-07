class ConversationsController < ApplicationController
  respond_to :html
  respond_to :js, only: [:reply, :destroy]

  before_filter :load_conversation, only: [:show, :reply, :destroy]

  def index
    @conversations = current_user.conversations
  end

  def show
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
    @conversation.messages.build(body: params[:body], from_id: current_user.id,
      to_id: @conversation.to == current_user ?
             @conversation.from.id : @conversation.to.id )
    if @conversation.save
      respond_to do |format|
        format.html { redirect_to user_conversations_path(current_user) }
        format.js
      end
    else
      render 'show'
    end
  end

  def destroy
    @conversation.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def load_conversation
      @conversation = Conversation.find(params[:id])
    end

end
