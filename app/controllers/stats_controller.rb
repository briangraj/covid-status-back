class StatsController < ApplicationController
  def total
    allowed_params = params.permit Case.total_allowed_params
    @count = Case.where_with_scopes(allowed_params).count

    render json: { count: @count }, status: :ok
  end

  def deaths
    allowed_params = params.permit Case.deaths_allowed_params
    @count = Case.where_with_scopes(allowed_params)
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
