statusClasses =
  pending: 'label-default'
  passed: 'label-success'
  build_failed: 'label-danger'

Vue.component 'solution-status-label',
  template: '#solution-status-label'
  props: ['solutionId', 'status']

  computed:
    labelClass: -> statusClasses[@status]

  created: ->
    channel = @$root.$dispatcher.subscribe "solution_#{@solutionId}", =>
      channel.bind 'changed', (solution) =>
        console.log solution
        @status = solution.status

      # channel.bind 'build_failed', (solution) =>
      #   console.log event, solution
