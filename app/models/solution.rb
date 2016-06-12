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
      transitions from: :passed, to: :pending
      transitions from: :build_failed, to: :pending
      success do
        notify_clients(:pending)
        SolutionJudgementJob.perform_later(self)
      end
    end

    event :judge do
      transitions from: :pending, to: :judging
      success do
        notify_clients(:judging)
      end
    end

    event :fail_build do
      transitions from: :judging, to: :build_failed
      success { notify_clients(:build_failed) }
    end

    event :pass do
      transitions from: :judging, to: :passed
      success { notify_clients(:passed) }
    end
  end

  def judge_sync
    Processing.build_str(source)
  end

  private

  def notify_clients(event)
    WebsocketRails[:solution_status].trigger event, self
  end
end
