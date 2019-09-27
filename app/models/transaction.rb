# Class Transaction provides details about user's transaction for particular scheme or investment
#
#
class Transaction
  include Mongoid::Document

  field :units, type: Float
  field :amount, type: Float
  field :date, type: Float

  #@todo use this for handling bot debit/credit transactions
  #field :direction , type: Boolean

  ## associations
  belongs_to :scheme
  belongs_to :investment

  ## indexes
  # scheme wise ascending and date wise descending index as most of the time we will deal with fresh NAV details
  index({ scheme_id: 1, investment_id: 1 })

  ##validations
  validates :units, :amount, :investment_id, :scheme_id, :date, presence: true
  validates :units, :amount, numericality: { greater_than_or_equal_to: 0 }
end