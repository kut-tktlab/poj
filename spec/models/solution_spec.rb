require 'rails_helper'

RSpec.describe Solution, type: :model do
  it 'is valid with a source and status' do
    solution = FactoryGirl.build(:solution)
    expect(solution).to be_valid
  end

  it 'is invalid without a source' do
    solution = FactoryGirl.build(:solution, source: '')
    expect(solution).not_to be_valid
  end
end
