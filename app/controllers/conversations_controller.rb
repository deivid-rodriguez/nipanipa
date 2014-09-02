class ConversationsController < ApplicationController
  respond_to :html
  respond_to :js, only: [:reply, :destroy]

  before_action :authenticate_user!
  before_action :load_user, only: [:index]
  before_action :load_conversation, only: [:show, :reply, :destroy]
  before_action :set_page_id

  def index
    @conversations = Conversation.non_deleted(current_user)
  end

  def show
    @message = Message.new
  end

  def new
    @conversation = Conversation.new(to_id: params[:to])
    @conversation.messages.build
  end

  def create
    @conversation = Conversation.new(conversation_params.merge(
        to_id: conversation_params[:messages_attributes]['0'][:to_id],
        from_id: conversation_params[:messages_attributes]['0'][:from_id]))
    if @conversation.save
      redirect_to conversations_path, notice: t('conversations.create.success')
    else
      flash.now[:error] = t('conversations.create.error')
      render 'new'
    end
  end

  def reply
    @conversation.messages.build(body:    params[:body],
                                 from_id: current_user.id,
                                 to_id:   other_user.id)
    @conversation.reset_deleted_marks
    unless @conversation.save
      flash.now[:error] = t('conversations.reply.error')
    end
    respond_with(@conversation, location: conversation_path(@conversation))
  end

  def destroy
    @conversation.mark_as_deleted(current_user)
    @conversation.destroy if @conversation.deleted_by_both?
    flash.now[:notice] = t('conversations.destroy.success')
    respond_with(@conversation, location: conversations_path)
  end

  private

  def conversation_params
    params.require(:conversation)
          .permit(:subject, messages_attributes: [:body, :from_id, :to_id])
  end

  # Some actions need this variable in the view
  def load_user
    @user = current_user
  end

  def load_conversation
    @conversation = Conversation.non_deleted(current_user).find(params[:id])
  end

  def other_user
    current_user == @conversation.to ? @conversation.from : @conversation.to
  end

  def set_page_id
    @page_id = :conversations
  end
end
