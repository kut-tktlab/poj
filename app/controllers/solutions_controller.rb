class SolutionsController < ApplicationController
  before_action :solution, only: [:edit, :show]

  add_breadcrumb '解答一覧', :solutions_path
  add_breadcrumb '投稿', :new_solution_path, only: [:new]
  add_breadcrumb '詳細', :solution_path, only: [:show, :edit]
  add_breadcrumb '編集', :edit_solution_path, only: [:edit]

  def index
    @solutions = Solution.all
  end

  def create
    @solution = Solution.new(solution_params)

    if @solution.save
      @solution.request_judgement!
      redirect_to @solution
    else
      render :new
    end
  end

  def new
    @solution = Solution.new
  end

  def edit
  end

  def show
  end

  def update
    if solution.update(solution_params)
      solution.request_judgement!
      redirect_to solution
    else
      render :edit
    end
  end

  def destroy
    solution.destroy
    redirect_to :solutions
  end

  private

  def solution_params
    params.require(:solution).permit(:source)
  end

  def solution
    @solution ||= Solution.find(params[:id])
  end
end
