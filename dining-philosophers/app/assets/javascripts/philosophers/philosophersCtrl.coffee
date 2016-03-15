angular.module('philosophers').controller 'PhilosophersCtrl'
, ['$http',
    'philosopherService',
    'sticksService'
    ($http, philosopherService, stickService) ->
      new class PhilosophersController
        constructor: ->
          @newPhilosopherName = 'Generic Philosopher'

        currentPhilosopher: ->
          philosopherService.ownPhilosopher

        philosophers: ->
          philosopherService.philosophers

        participate: ->
          console.info 'participating'
          philosopherService.participate(@newPhilosopherName)
          stickService.loadSticks()

        leave: ->
          console.info 'leaving'
          philosopherService.leave()
          stickService.loadSticks()

        think: ->
          philosopherService.think()
]
