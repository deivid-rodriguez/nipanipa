#
# Message related js functionality
#
jQuery ->
  $('.message-action').click ->
    $(this).find('input').hide()
    $(this).find('img').show()

  autosize($('#message_body'))
