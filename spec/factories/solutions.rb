FactoryGirl.define do
  factory :solution do
    source '// line(0, 0, 100, 100);'
    status :initial

    factory :invalid_solution do
      source ''
    end

    factory :build_failed_solution do
      source 'line(0, 0, 100);'
    end
  end
end
