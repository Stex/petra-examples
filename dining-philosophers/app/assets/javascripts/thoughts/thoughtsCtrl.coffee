angular.module('philosophers').controller 'ThoughtsController'
, ['thoughtsService',
    'philosopherService',
    '$interval',
    (thoughtsService, philosopherService, $interval) ->
      new class ThoughtsController
        constructor: () ->
          $interval @showThoughts, 3000

        showThoughts: () =>
          angular.forEach philosopherService.philosophers, (phil) =>
            thoughtsService.showThought(phil.number)
  ]
