# frozen_string_literal: true

# Class Investment provides details about user's investment portfolio in various schemes
#
#
class Investment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :units, type: Float
  field :invested_amount, type: Float
  field :xirr, type: Float
  field :current_value, type: Float
  field :absolute_return_percentage, type: Float
  field :last_updated_date, type: Date

  ## associations
  belongs_to :scheme
  belongs_to :portfolio

  has_many :transactions

  ## indexes
  # scheme wise ascending and date wise descending index as most of the time we will deal with fresh NAV details
  index(scheme_id: 1, portfolio_id: 1)

  # validations
  validates :units, :invested_amount, :portfolio_id, :scheme_id, :last_updated_date, presence: true
  validates :units, :invested_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :xirr, :absolute_return_percentage, numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100 }
end
