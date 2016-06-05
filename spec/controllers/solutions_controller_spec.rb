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

  describe '#edit' do
    let!(:solution) { FactoryGirl.create(:solution) }

    it 'renders :edit template' do
      get :edit, id: solution
      expect(response).to render_template(:edit)
    end

    it 'assigns the requested solution to @solution' do
      get :edit, id: solution
      expect(assigns(:solution)).to eq(solution)
    end
  end

  describe '#show' do
    let!(:solution) { FactoryGirl.create(:solution) }

    it 'renders :show template' do
      get :show, id: solution
      expect(response).to render_template(:show)
    end

    it 'assigns the requested solution to @solution' do
      get :show, id: solution
      expect(assigns(:solution)).to eq(solution)
    end
  end

  describe '#update' do
    let!(:solution) { FactoryGirl.create(:solution) }

    context 'with valid attributes' do
      it 'locates the requested solution to @solution' do
        patch :update, id: solution, solution: FactoryGirl.attributes_for(:solution)
        expect(assigns(:solution)).to eq(solution)
      end

      it "changes solution's attributes" do
        patch :update, id: solution, solution: FactoryGirl.attributes_for(:solution, source: '// changed')
        solution.reload
        expect(solution.source).to eq('// changed')
      end

      it 'redirects to the updated solution' do
        patch :update, id: solution, solution: FactoryGirl.attributes_for(:solution)
        expect(response).to redirect_to(solution)
      end
    end

    context 'with invalid attributes' do
      it "changes solution's attributes" do
        patch :update, id: solution, solution: FactoryGirl.attributes_for(:invalid_solution)
        solution.reload
        expect(solution.source).not_to eq('')
      end

      it 'redirects to the updated solution' do
        patch :update, id: solution, solution: FactoryGirl.attributes_for(:invalid_solution)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    let!(:solution) { FactoryGirl.create(:solution) }

    it 'deletes the solution' do
      expect {
        delete :destroy, id: solution
      }.to change(Solution, :count).by(-1)
    end

    it 'redirects to solutions#index' do
      delete :destroy, id: solution
      expect(response).to redirect_to solutions_url
    end
  end
end
