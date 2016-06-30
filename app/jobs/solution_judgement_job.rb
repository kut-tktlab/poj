class SolutionJudgementJob < ActiveJob::Base
  queue_as :default

  def perform(solution)
    solution.reload.judge!

    if !solution.judge_sync
      solution.pass!
    else
      solution.fail_build!
    end
  end
end
