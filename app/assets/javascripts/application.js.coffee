#= require jquery
#= require bootstrap-sprockets
#= require jquery_ujs
#= require turbolinks
#= require_tree .
#= require websocket_rails/main

dispatcher = new WebSocketRails('localhost:3000/websocket');

dispatcher.on_open = (data) ->
  console.log('Connection has been established: ', data)

  channel = dispatcher.subscribe('solution_status')

  ['pending', 'judging', 'build_failed', 'passed'].forEach (event) ->
    channel.bind event, (data) ->
      console.log(event, data)
