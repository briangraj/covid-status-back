module ScopeFromTo
  extend ActiveSupport::Concern

  class_methods do
    def scope_from_to(*syms)
      syms.each do |field|
        field_string = field.to_s

        scope field_string + "_from", ->(value) { where("#{field_string} >= ?", value) }
        scope field_string + "_to", ->(value) { where("#{field_string} <= ?", value) }
      end
    end
  end
end
