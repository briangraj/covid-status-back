class StatsController < ApplicationController
  def total
    @count = Case.count

    render json: { count: @count }, status: :ok
  end
end
