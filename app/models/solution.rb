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
    style_failed: 4,
    passed: 10
  }

  aasm column: :status, enum: true do
    state :initial, initial: true
    state :pending
    state :judging
    state :build_failed
    state :style_failed
    state :passed

    after_all_events { notify_clients }

    event :request_judgement do
      transitions from: :initial, to: :pending
      transitions from: :passed, to: :pending
      transitions from: :build_failed, to: :pending
      transitions from: :style_failed, to: :pending

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

    event :fail_style do
      transitions from: :judging, to: :style_failed
    end

    event :pass do
      transitions from: :judging, to: :passed
    end
  end

  def check_build
    Processing::Sketch.from_source(source).build
  end

  def check_style
    Processing::Sketch.from_source(source).check_style
  end

  private

  def notify_clients
    SolutionNotificationJob.perform_later(self) if persisted?
  end
end
