class ConversationsController < ApplicationController
  respond_to :html
  respond_to :js, only: [:reply, :destroy]

  before_filter :load_conversation, only: [:show, :reply, :destroy]

  def index
    @conversations = current_user.non_deleted_conversations
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
      redirect_to user_conversations_path(current_user),
                  notice: t('conversations.create.success')
    else
      flash.now[:error] = t('conversations.create.error')
      render 'new'
    end
  end

  def reply
    @conversation.messages.build(body:    params[:body],
                                 from_id: current_user.id,
                                 to_id:   other_user.id )
    @conversation.reset_deleted_marks
    if !@conversation.save
      flash.now[:error] = t('conversations.reply.error')
    end
    respond_with(@conversation,
                 location: user_conversation_path(current_user, @conversation))
  end

  def destroy
    @conversation.mark_as_deleted(current_user)
    @conversation.destroy if @conversation.deleted_by_both?
    flash[:notice] = t('Conversations.destroy.success')
    respond_with(@conversation, location: user_conversations_path(current_user))
  end

  private

    def load_conversation
      @conversation = Conversation.find(params[:id])
    end

    def other_user
      current_user == @conversation.to ? @conversation.from : @conversation.to
    end
end
