class SolutionsController < ApplicationController
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
    @solution = Solution.find(params[:id])
  end

  def show
    @solution = Solution.find(params[:id])
  end

  def update
    @solution = Solution.find(params[:id])

    if @solution.update(solution_params)
      @solution.request_judgement!
      redirect_to @solution
    else
      render :edit
    end
  end

  def destroy
    @solution = Solution.find(params[:id])
    @solution.destroy
    redirect_to :solutions
  end

  private

  def solution_params
    params.require(:solution).permit(:source)
  end
end
