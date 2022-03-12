class StatsController < ApplicationController
  def total
    @count = Case.where(cases_query_param).count

    render json: { count: @count }, status: :ok
  end

  def deaths
    @count = Case.where.not(death_date: nil)
                 .count

    render json: { count: @count }, status: :ok
  end

  private
  def cases_query_param
    params.permit(:gender)
  end
end
