#
# Set smaller line-height for multiline tips
#
jQuery ->
  cnt = $('#categoriesinfo').height()
  if cnt > 24
    $('#categoriesinfo').css('line-height', '18px')

  cnt = $('#languagesinfo').height()
  if cnt > 24
    $('#languagesinfo').css('line-height', '18px')
