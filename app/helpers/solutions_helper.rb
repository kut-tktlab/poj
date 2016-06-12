module SolutionsHelper
  def status_label(solution)
    render partial: 'status_label', locals: { solution: solution }
  end
end
