# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.sse_alert').hide()

source = new EventSource('/page_updates/events')

source.addEventListener 'message', (e) ->
  obj = JSON.parse(e.data)
  html_val = "<div class='row single-update'><div class='col-md-2 user-email'> #{obj.email} </div><div class='col-md-10'> #{obj.content} </div><div class='col-md-10 ago_time'>#{obj.time}</div></div>"
  $('.status_container .col-md-12').prepend(html_val)

source.addEventListener 'custom_alert', (e) ->
  obj = JSON.parse(e.data)
  $('.sse_alert').text "New update from #{obj.email}"
  $('.sse_alert').show()
  $('.sse_alert').delay(3200).fadeOut(300);


