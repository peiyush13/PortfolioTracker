class NavUpdaterWorker
  include Sidekiq::Worker

  def perform(name, count)
    begin
      # initialize fund house,schemes and nav_details
      fund_house = FundHouse.find_by(name: 'Axis Mutual Fund')
      schemes = []
      nav_details = []
      nav_details_data = []
      tp = 1
      from_date = Date.yesterday.strftime('%d-%b-%Y')
      to_date = Date.today.strftime('%d-%b-%Y')
      uri = URI('http://portal.amfiindia.com/DownloadNAVHistoryReport_Po.aspx')
      params = { mf: fund_house.fundhouse_id, tp: tp, frmdt: from_date, todt: to_date }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      nav_data = res.body.split("\r\n").reject{ |i| i.blank? || i.split(';').count == 1 }.drop(1)
      nav_data.each do |nav_details|
        data = nav_details.split(';')
        scheme = schemes.find { |sc| sc.code == data[0] }
        if !scheme.present?
          scheme = Scheme.find_or_create_by(code: data[0], name: data[1], isin_div_payout: data[2], isin_div_reinvestment: data[3], fund_house: fund_house)
          schemes << scheme
        end
        nav_details_data << { scheme_id: scheme.id, nav: data[4].to_f, repurchasing_price: data[5].to_f, sale_price: data[6].to_f, date: Date.parse(data[7]), created_at: DateTime.now, updated_at: DateTime.now }
      end
      NavDetail.collection.insert_many(nav_details_data)
    rescue StandardError, SocketError => error
      puts "Error in Execution :- #{error.message}"
    end
  end
end