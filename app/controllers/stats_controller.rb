class StatsController < ApplicationController
  def total
    @count = Case.count

    render json: { count: @count }, status: :ok
  end

  def deaths
    @count = Case.where.not(death_date: nil)
                 .count

    render json: { count: @count }, status: :ok
  end
end
