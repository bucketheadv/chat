$(document).ready () ->
  sender_id       = $("div.sender_id").html()
  conversation_id = $("div.conversation_id").html()
  $(".message-window").scrollTop($(".message-window")[0].scrollHeight)
  generate_view = (message) ->
    # console.log(JSON.stringify(message))
    canDelete = false
    if message['sender_id'].toString() == sender_id
      color = '#fedcba'
      canDelete = true
    else
      color = '#cdcdef'
    str = "<div class='ui segment'>"
    str += "<div class='ui comments'>"
    str += "<div class='ui menu comment' style='padding: 5px 10px; background: "+ color + "'>"
    str += "<div class='content'>"
    str += "<a href='#'>" + message['sender_email'] + "</a>"
    str += "<div class='metadata'><span class='date'>" + message['created_at'] + "</span>"
    if canDelete
      str += '<a data-confirm="你确定?" class="ui inverted red button mini" rel="nofollow" data-method="delete" href="/conversations/' + message['conversation_id'] + '/messages/' + message['message_id'] + '">删除</a>'
    str += "</div><div class='text'>" + message['content'] + "</div>"
    str += "</div></div></div></div>"
    return str

  App.conversation = App.cable.subscriptions.create "ConversationChannel",
    connected: ->
      console.log("Connected to server!\n")
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # console.log("Got data : #{JSON.stringify(data)}")
      data = data['message']
      if (data['conversation_id'].toString() == conversation_id)
        $(".ui.example").append(generate_view(data))
        $(".message-window").scrollTop($(".message-window")[0].scrollHeight)
      # Called when there's incoming data on the websocket for this channel

    speak: (from, to, message)->
      @perform 'speak', sender_id: from, conversation_id: to, message: message

  $(document).on "keypress", '[data-behavior~=conversation_speaker]', (event) ->
    if sender_id == null || sender_id.trim() == '' || conversation_id == null || conversation_id.trim() == ''
      return true
    if event.target.value.trim() == ''
      return true
    if event.keyCode is 13
      App.conversation.speak sender_id, conversation_id, event.target.value
      event.target.value = ''
      event.preventDefault()
