class SolutionsController < ApplicationController
  def index
    @solutions = Solution.all
  end

  def create
    @solution = Solution.new(solution_params)

    if @solution.save
      redirect_to @solution
    else
      render :new
    end
  end

  def new
    @solution = Solution.new
  end

  def edit
    @solution = Solution.find(params[:id])
  end

  def show
    @solution = Solution.find(params[:id])
  end

  def update
    @solution = Solution.find(params[:id])

    if @solution.update(solution_params)
      redirect_to @solution
    else
      render :edit
    end
  end

  def destroy
    # TODO
  end

  private

  def solution_params
    params.require(:solution).permit(:source)
  end
end
