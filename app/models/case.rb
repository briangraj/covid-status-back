class Case < ApplicationRecord

  # TODO generalize to avoid duplicates
  scope :age_from, ->(age) { where("age >= ?", age) }
  scope :age_to, ->(age) { where("age <= ?", age) }
  scope :diagnosis_date_from, ->(date) { date_from("diagnosis_date", date) }
  scope :diagnosis_date_to, ->(date) { date_to("diagnosis_date", date) }
  scope :death_date_from, ->(date) { date_from("death_date", date) }
  scope :death_date_to, ->(date) { date_to("death_date", date) }

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

  private
  def self.date_from(field, date)
    where("#{field} >= ?", date)
  end

  def self.date_to(field, date)
    where("#{field} <= ?", date)
  end

end
