angular.module('philosophers').service 'thoughtsService'
, ['$http', '$timeout',
    ($http, $timeout) ->
      new class ThoughtsService
        constructor: ->
          @thoughts = {}
          @pastThoughts = {}
          @timeouts = {}

        addThought: (number, thought) ->
          @thoughts[number] ||= []
          @pastThoughts[number] ||= []

          if $.inArray(thought, @pastThoughts[number]) == -1
            @thoughts[number].push(thought)
            @pastThoughts[number].push(thought)

        thoughtQueue: (number) =>
          @thoughts[number] ||= []

        nextThought: (number) =>
          @thoughtQueue(number).shift()

        showThought: (number) =>
          if @thoughtQueue(number).length > 0 && !@timeouts[number]
            @timeouts[number] = true
            thought = @nextThought(number)
            tt = $("#philosopher_#{number}").tooltip
              'title': thought
              'placement': 'right'
              'trigger': 'manual'
              'container': 'body'

            tt.tooltip('show')

            $timeout () =>
              console.info 'hiding thought'
              tt.tooltip('destroy')
              @timeouts[number] = false
            , 7000
  ]

