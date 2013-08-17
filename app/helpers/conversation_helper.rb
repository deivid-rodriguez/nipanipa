module ConversationHelper
  def other_user(conv)
    current_user == conv.from ? conv.to : conv.from
  end
end
