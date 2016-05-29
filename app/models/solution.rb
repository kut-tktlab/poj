# 問題に対する解答を表す
class Solution < ActiveRecord::Base
  # 解答プログラムの判定状態を表す
  enum :status, { pending: 0, checking: 1, syntax_error: 2 }

  # TODO
end
