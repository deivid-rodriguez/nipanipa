# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Set smaller line-height for multiline tips
jQuery ->
  cnt = $("#categoriesinfo").height()
  if cnt > 24
    $("#categoriesinfo").css("line-height", "18px")

  cnt = $("#languagesinfo").height()
  if cnt > 24
    $("#languagesinfo").css("line-height", "18px")
