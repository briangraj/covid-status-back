class Case < ApplicationRecord
  include ScopeFromTo

  scope_from_to :age, :diagnosis_date, :death_date

  def self.where_with_scopes(hash)
    base_query = self.all

    hash.each do |key, value|
      if respond_to? key
        base_query = base_query.send(key, value)
      else
        base_query = base_query.where(key => value)
      end
    end

    base_query
  end

  def self.allowed_params
    return [:gender, :age_from, :age_to]
  end

  def self.total_allowed_params
    allowed_params.concat [:diagnosis_date_from, :diagnosis_date_to]
  end

  def self.deaths_allowed_params
    allowed_params.concat [:death_date_from, :death_date_to]
  end

end
