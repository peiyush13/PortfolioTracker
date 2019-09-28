# frozen_string_literal: true

include Xirr

class HomeController < ApplicationController
  def index
    if !current_user
    else
      redirect_to '/user/investments/new'
    end
  end

  def value_calculator
    scheme = Scheme.find(params[:fund_name])
    nav_details = scheme.nav_details.where(date: { '$gte': Date.parse(params[:date_of_investment]) }).asc(:date).first
    units = params[:amount].to_f / nav_details.nav
    current_value = (units * scheme.current_nav).round(2)
    absolute_returns = (((current_value / params[:amount].to_f) * 100) - 100).round(2)
    # xirr calculation logic using xirr gem
    cf = Xirr::Cashflow.new
    cf << Xirr::Transaction.new(-params[:amount].to_f, date: Date.parse(params[:date_of_investment]).strftime('%Y-%m-%d').to_date)
    cf << Xirr::Transaction.new(current_value, date: Date.today.strftime('%Y-%m-%d').to_date)
    xirr = (cf.xirr.to_f * 100).round(2)
    respond_to do |format|
      format.json { render json: { current_value: current_value, absolute_returns: absolute_returns, xirr: xirr } }
      format.html {}
    end
  end
end
