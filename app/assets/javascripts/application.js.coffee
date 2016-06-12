#= require jquery
#= require bootstrap-sprockets
#= require jquery_ujs
#= require turbolinks
#= require vue.min.js
#= require websocket_rails/main
#= require_tree .
#= require_self

$ ->
  window.app = new Vue
    el: 'body'

    created: ->
      @$dispatcher = new WebSocketRails('localhost:3000/websocket');

      @$dispatcher.on_open = (data) ->
        console.log('Connection has been established: ', data)
