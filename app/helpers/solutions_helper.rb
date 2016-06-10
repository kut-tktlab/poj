module SolutionsHelper
  def status_label(solution)
    status_classes = {
      pending: 'label-default',
      passed: 'label-success',
      build_failed: 'label-danger'
    }

    label_class = status_classes[solution.status.to_sym]
    content_tag :span, solution.status, class: "label #{label_class}"
  end
end
