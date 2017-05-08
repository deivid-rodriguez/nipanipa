# frozen_string_literal: true

#
# Controller for conversations between users
#
class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user
  before_action :load_conversation, only: %i[show destroy]

  def show
    @message = Message.new(default_message_params)
  end

  def index
    @conversations = Message.involving(current_user)
  end

  def update
    @message = Message.new(message_params)

    @message.notify_recipient if @message.save

    respond_to do |format|
      format.html { redirect_to conversation_path(@message.recipient) }
      format.js
    end
  end

  def destroy
    @conversation.delete_by(current_user.id) if @conversation.present?

    respond_to do |format|
      format.html { redirect_to conversations_path }
      format.js { set_flash_after_destroy }
    end
  end

  private

  def set_flash_after_destroy
    if @conversation.present?
      flash.now[:notice] = t("conversations.destroy.success")
    else
      flash.now[:error] = t("conversations.destroy.error")
    end
  end

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
end
