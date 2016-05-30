require 'rails_helper'

RSpec.describe SolutionsController, type: :controller do
  describe '#index' do
    let!(:solutions) do
      [
        FactoryGirl.create(:solution, source: '// problem 1'),
        FactoryGirl.create(:solution, source: '// problem 2')
      ]
    end

    it 'populates an array of all solutions' do
      get :index
      expect(assigns(:solutions)).to match_array(solutions)
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      let(:solution_params) do
        FactoryGirl.attributes_for(:solution, source: '// problem 1')
      end

      it 'saves the new solution in the database' do
        expect {
          post :create, solution: solution_params
        }.to change(Solution, :count).by(1)
      end

      it 'redirects to solutions#show' do
        post :create, solution: solution_params
        expect(response).to redirect_to solution_path(assigns(:solution))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_solution_parmas) do
        FactoryGirl.attributes_for(:solution, source: '')
      end

      it 'does not save the new solution in the database' do
        expect {
          post :create, solution: invalid_solution_parmas
        }.not_to change(Solution, :count)
      end

      it 're-renders solutions#new' do
        post :create, solution: invalid_solution_parmas
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#new' do
    it 'renders solutions#new' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new solutions to @solution' do
      get :new
      expect(assigns(:solution)).to be_a_new(Solution)
    end
  end

  describe '#edit'
  describe '#show'
  describe '#update'
  describe '#destroy'
end
