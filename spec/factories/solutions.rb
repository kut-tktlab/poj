FactoryGirl.define do
  factory :solution do
    source '// Processing source code'
    status :pending

    factory :invalid_solution do
      source ''
      status :pending
    end
  end
end
