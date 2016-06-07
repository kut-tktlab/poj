# 問題に対する解答を表す
class Solution < ActiveRecord::Base
  include AASM
  validates :source, presence: true

  # 解答プログラムの判定状態を表す
  enum status: {
    initial: 0,
    pending: 1,
    judging: 2,
    build_failed: 3,
    passed: 4
  }

  aasm column: :status, enum: true do
    state :initial, initial: true
    state :pending
    state :judging
    state :build_failed
    state :passed

    event :request_judgement do
      transitions from: :initial, to: :pending
      success { enqueue_judgement_job }
    end

    event :judge do
      transitions from: :pending, to: :judging
      success { judge_source }
    end

    event :fail_build do
      transitions from: :judging, to: :build_failed
    end

    event :pass do
      transitions from: :judging, to: :passed
    end

    event :reset do
      transitions from: :build_failed, to: :initial
      transitions from: :passed, to: :initial
    end
  end

  private

  def judge_source
    if Processing.build_str(source)
      pass!
    else
      fail_build!
    end
  end

  def enqueue_judgement_job
    SolutionJudgementJob.perform_later(self)
  end
end
