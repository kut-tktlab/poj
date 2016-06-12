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

    after_all_events { notify_clients }

    event :request_judgement do
      transitions from: :initial, to: :pending
      transitions from: :passed, to: :pending
      transitions from: :build_failed, to: :pending
      success do
        SolutionJudgementJob.perform_later(self)
      end
    end

    event :judge do
      transitions from: :pending, to: :judging
    end

    event :fail_build do
      transitions from: :judging, to: :build_failed
    end

    event :pass do
      transitions from: :judging, to: :passed
    end
  end

  def judge_sync
    Processing.build_str(source)
  end

  private

  def notify_clients
    SolutionNotificationJob.perform_later(self)
  end
end
