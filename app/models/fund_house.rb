# frozen_string_literal: true

# Class FundHouse provides detailed information about found house
#
#
class FundHouse
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :fundhouse_id, type: String, default: '' # fund house's unique id prior to AMFI
  field :aum, type: Float, default: 0.0 # Asset under management for fund_house
  field :fund_managers_info, type: Array, default: [] # @todo convert to fund_manager model to store manager's folio details

  has_many :schemes

  validates :name, presence: true
end
