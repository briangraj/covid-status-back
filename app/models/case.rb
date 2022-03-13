class Case < ApplicationRecord

  scope :age_from, ->(age) { where("age >= ?", age) }
  scope :age_to, ->(age) { where("age <= ?", age) }

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

end
