angular.module('philosophers').service 'sticksService'
, ['$http',
    '$interval',
    'philosopherService',
    'alertsService',
    ($http, $interval, philosopherService, alertsService) ->
      new class SticksService
        constructor: ->
          @sticks = []
          $interval @loadSticks, 2000
          @loadSticks()

        taken: (stick) ->
          stick.taken_by != null

        takenByCurrent: (stick) ->
          return false unless stick?
          stick.taken_by == philosopherService.ownPhilosopher.identifier

        takenByCurrentByPosition: (position) ->
          stick = philosopherService.ownPhilosopher?["#{position}_stick"]
          @takenByCurrent(stick)

        takenByOther: (stick) ->
          return false unless stick?
          @taken(stick) && !@takenByCurrent(stick)

        takenByOtherByPosition: (position) ->
          stick = philosopherService.ownPhilosopher?["#{position}_stick"]
          @takenByOther(stick)

        loadSticks: =>
          $http.get('/sticks.json')
          .success (response) =>
            @sticks = response
          .error (response) =>
            @sticks = []
            console.info response

        toggleStick: (position) ->
          if @takenByCurrentByPosition(position)
            @putStick(position)
          else
            @takeStick(position)

        takeStick: (position) ->
          $http.post("/sticks/take_#{position}")
          .success (response) =>
            philosopherService.loadOwnPhilosopher()
          .error (response) =>
            alertsService.addAlert('warning', response.message)
            philosopherService.loadOwnPhilosopher()

        putStick: (position) ->
          $http.post("/sticks/put_#{position}")
          .success (response) =>
            philosopherService.loadOwnPhilosopher()
            @loadSticks()
          .error (response) =>
            alertsService.addAlert('warning', response.message)
            philosopherService.loadOwnPhilosopher()

        commitTransaction: ->
          $http.post("/sticks/commit")
          .success (response) =>
            @loadSticks()
            philosopherService.loadOwnPhilosopher()
          .error (response) =>
            alertsService.addAlert('warning', response.message)
            philosopherService.loadOwnPhilosopher()
]

