require 'rails_helper'

RSpec.describe SolutionsController, type: :controller do
  describe '#index' do
    let!(:solutions) do
      [
        FactoryGirl.create(:solution, source: '// problem 1'),
        FactoryGirl.create(:solution, source: '// problem 2')
      ]
    end

    it 'populates an array of solutions' do
      get :index
      expect(assigns(:solutions)).to match_array(solutions)
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#create'
  describe '#new'
  describe '#edit'
  describe '#show'
  describe '#update'
  describe '#destroy'
end
