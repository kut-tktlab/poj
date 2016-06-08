class SolutionJudgementJob < ActiveJob::Base
  queue_as :default

  def perform(solution)
    solution.judge!
  end
end
