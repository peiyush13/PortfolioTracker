# frozen_string_literal: true

# Class Portfolio provides details about investments in schemes to the user
#
#
class Portfolio
  include Mongoid::Document
  include Mongoid::Timestamps

  field :invested_amount, type: Float
  field :xirr, type: Float
  field :current_value, type: Float
  field :absolute_return_percentage, type: Float

  ## associations
  belongs_to :user
  has_many :investments

  ## indexes
  # scheme wise ascending and date wise descending index as most of the time we will deal with fresh nav details
  index(user_id: 1)

  # #validations
  validates :invested_amount, :user_id, presence: true
  validates :invested_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :xirr, :absolute_return_percentage, numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100 }
end
