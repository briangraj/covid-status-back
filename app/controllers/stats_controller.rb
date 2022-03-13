class StatsController < ApplicationController
  def total
    allowed_params = rename_keys cases_query_param, { "date_from" => "diagnosis_date_from", "date_to" => "diagnosis_date_to" }
    @count = Case.where_with_scopes(allowed_params).count

    render json: { count: @count }, status: :ok
  end

  def deaths
    allowed_params = rename_keys cases_query_param, { "date_from" => "death_date_from", "date_to" => "death_date_to" }
    @count = Case.where_with_scopes(allowed_params)
                 .where.not(death_date: nil)
                 .count

    render json: { count: @count }, status: :ok
  end

  private
  def cases_query_param
    # TODO verify type or cast???
    params.permit(:gender, :age_from, :age_to, :date_from, :date_to)
  end

  def rename_keys(params, renames_hash)
    params.transform_keys do |key|
      renames_hash.key?(key) ? renames_hash[key] : key
    end
  end
end
