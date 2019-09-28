# frozen_string_literal: true

# Class Scheme provides details about the schemes prior to AMFI
#
# @author Piyush Wani <piyush.wani@amuratech.com>
#
class Scheme
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :name, type: String
  field :isin_div_payout, type: String, default: ''
  field :isin_div_reinvestment, type: String, default: ''
  field :fund_managers_info, type: Array, default: [] # @todo convert to fund_manager model to store manager's folio details
  field :aum, type: Float, default: 0.0 # Asset under management for fund_house

  # @todo convert this static _type to STI to store type specific details, also can be used for type based filtering
  # field :_type, type: String, default: ''

  # @todo add validations on inception_date presence
  field :inception_date, type: Date # represents the date from where fund has started

  # #associations
  belongs_to :fund_house
  has_many :nav_details

  # #validations
  validates :name, :code, :fund_house_id, presence: true

  def current_nav
    nav_details.desc(:date).first.nav
  end
end
