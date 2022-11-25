# frozen_string_literal: true

module HandHistoryGenericFilterScopes
  extend ActiveSupport::Concern

  included do
    scope :filter_by_join, lambda { |attr, value, extra_joins = nil|
      value.present? ? joins(extra_joins).where("#{attr}": value) : all
    }
    scope :filter_by_presence, lambda { |attr, value|
      # NOTE: since these params come directly from controllers, booleans are assumed to be strings
      # with 'true' or 'false' as values
      return all if value.blank?

      ActiveModel::Type::Boolean.new.cast(value) ? where.not("#{attr}": nil) : where("#{attr}": nil)
    }
    scope :filter_boolean, lambda { |attr, value|
      # NOTE: since these params come directly from controllers, booleans are assumed to be strings
      # with 'true' or 'false' as values
      return all if value.blank?

      ActiveModel::Type::Boolean.new.cast(value) ? where("#{attr}": true) : where("#{attr}": false)
    }
  end
end
