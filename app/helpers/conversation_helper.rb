#
# Helpers for rendering conversation pages
#
module ConversationHelper
  def other_user(conv)
    current_user == conv.from ? conv.to : conv.from
  end

  def from_starter?(message)
    message.from == message.conversation.from
  end
end
