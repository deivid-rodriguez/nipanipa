#
# Controller for conversations between users
#
# TODO: Get rid of `respond_with` or explicitly include the 'responders' gem.
#
class ConversationsController < ApplicationController
  respond_to :html
  respond_to :js, only: %i(update destroy)

  before_action :authenticate_user!
  before_action :set_page_id
  before_action :load_user
  before_action :load_conversation, only: %i(show destroy)

  def show
    @message = Message.new(default_message_params)
  end

  def index
    @conversations = Message.involving(current_user)
  end

  def update
    @message = Message.new(message_params)

    if @message.save
      @message.notify_recipient
      flash.now[:notice] = t('conversations.update.success')
    else
      flash.now[:error] = t('conversations.update.error')
    end

    respond_with(@message, location: conversation_path(@message.recipient))
  end

  def destroy
    if @conversation.present?
      @conversation.delete_by(current_user.id)

      flash.now[:notice] = t('conversations.destroy.success')
    else
      flash.now[:error] = t('conversations.destroy.error')
    end

    respond_with(@conversation, location: conversations_path)
  end

  private

  def load_conversation
    @conversation = current_user.messages_with(params[:id])
  end

  def message_params
    params.require(:message).permit(:body).merge(default_message_params)
  end

  def default_message_params
    { sender_id: current_user.id, recipient_id: params[:id] }
  end

  def load_user
    @user = current_user
  end

  def set_page_id
    @page_id = :messages
  end
end
