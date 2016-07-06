class SolutionJudgementJob < ActiveJob::Base
  queue_as :default

  def perform(solution)
    solution.reload.judge!

    if !solution.check_style
      solution.pass!
    else
      solution.fail_build!
    end
  end
end
