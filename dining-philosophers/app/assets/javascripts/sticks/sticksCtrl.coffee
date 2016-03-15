angular.module('philosophers').controller 'SticksCtrl'
, ['$http',
    'sticksService',
    ($http, sticksService) ->
      new class SticksController
        sticks: ->
          sticksService.sticks

        stickButtonClasses: (position) ->
          {
            'btn-success': sticksService.takenByCurrentByPosition(position),
            'btn-warning disabled': sticksService.takenByOtherByPosition(position)
          }

        toggle: (position) ->
          console.info position
          sticksService.toggleStick(position)

        commit: ->
          sticksService.commitTransaction()
]
