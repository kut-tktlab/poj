class SolutionNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(solution)
    WebsocketRails["solution_#{solution.id}"].trigger 'changed', solution
  end
end
