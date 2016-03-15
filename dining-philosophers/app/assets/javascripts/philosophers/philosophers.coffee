angular.module('philosophers').service 'philosopherService'
, ['$http',
    '$interval',
    'alertsService',
    'thoughtsService',
    ($http, $interval, alertsService, thoughtsService) ->
      new class PhilosopherService
        constructor: ->
          @philosophers = []
          @ownPhilosopher = null
          $interval @loadPhilosophers, 2000
          $interval @loadOwnPhilosopher, 2000
          @loadOwnPhilosopher()
          @loadPhilosophers()

        loadOwnPhilosopher: () =>
          $http.get('/philosopher.json')
          .success (response) =>
            @ownPhilosopher = response
          .error (response) =>
            @ownPhilosopher = null

        loadPhilosophers: =>
          $http.get('/philosophers.json')
          .success (response) =>
            if @philosopherListChanged(response)
              @philosophers = response

            angular.forEach response, (phil) =>
              if phil.thoughts?
                thoughtsService.addThought(phil.number, phil.thoughts)
          .error (response) =>
            console.error 'I am error'
            @philosophers = []

        participate: (name) ->
          $http.post '/philosophers',
            'name': name
          .success (response) =>
            @loadPhilosophers()
            @loadOwnPhilosopher()
          .error (response) ->
            console.error response

        leave: ->
          $http.post '/philosophers/leave'
          .success (response) =>
            @ownPhilosopher = null
            @loadPhilosophers()
          .error (response) =>
            alertsService.addAlert('danger', response.message)

        think: ->
          thought = bullshit.buzzword()

          $http.post '/philosopher/think',
            'thoughts': thought
          .success (response) =>
            @loadPhilosophers()
          .error (response) =>
            alertsService.addAlert('danger', response.message)

        philosopherListChanged: (newPhilosophers) =>
          oldIds = $.map @philosophers, (phil) =>
            phil.id
          newIds = $.map newPhilosophers, (phil) =>
            phil.id

          JSON.stringify(oldIds.sort()) != JSON.stringify(newIds.sort())
]

