class SolutionJudgementJob < ActiveJob::Base
  queue_as :default

  def perform(solution)
    solution.reload.judge!

    check_failed = [:build, :style].find { |name| solution.__send__("check_#{name}") }

    if check_failed
      solution.__send__("fail_#{check_failed}!")
    else
      solution.pass!
    end
  end
end
