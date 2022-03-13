class StatsController < ApplicationController
  def total
    @count = Case.where_with_scopes(cases_query_param).count

    render json: { count: @count }, status: :ok
  end

  def deaths
    @count = Case.where_with_scopes(cases_query_param)
                 .where.not(death_date: nil)
                 .count

    render json: { count: @count }, status: :ok
  end

  private
  def cases_query_param
    # TODO verify type or cast???
    params.permit(:gender, :age_from, :age_to)
  end
end
