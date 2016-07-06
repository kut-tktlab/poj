# 問題に対する解答を表す
class Solution < ActiveRecord::Base
  include AASM
  has_many :statuses, dependent: :destroy
  validates :source, presence: true

  def judge!
    statuses = []

    [:build, :style].all? do |name|
      e = __send__("#{name}_valid?")
      errors = @solution_errors[name] ||= []
      errors << e if e
      statuses << Status.new()
    end
  end

  def check_statuses
    [:build, :style].each do |name|
      messages = __send__("judge_#{name}")

      messages.each do |msg|
        statuses.build(message: msg)
      end
    end
  end

  def judge_build
    sketch.build
  end

  def judge_style
    sketch.check_style
  end

  def sketch
    if source_changed?
      @sketch = Processing::Sketch.from_source(source)
    else
      @sketch
    end
  end

  private

  def notify_clients
    SolutionNotificationJob.perform_later(self) if persisted?
  end
end
