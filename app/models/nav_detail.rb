# Class NavDetails provides detailed information about fund specific date wise details about NAV, repurchasing price and sale price
#
#
class NavDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nav, type: Float
  field :repurchasing_price, type: Float
  field :sale_price, type: Float
  field :date, type: Date

  ## associations
  belongs_to :scheme

  ## indexes
  # scheme wise ascending and date wise descending index as most of the time we will deal with fresh NAV details
  index({ scheme_id: 1, date: -1 })

  ##validations
  validates :nav, :repurchasing_price, :sale_price, :date, :scheme_id, presence: true
  validates :nav, :repurchasing_price, :sale_price, numericality: { greater_than_or_equal_to: 0 }
end