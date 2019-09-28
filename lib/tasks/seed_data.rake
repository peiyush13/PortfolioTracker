namespace :seed_data do
  desc "Seed AMFI Data and put it in NAV Details"

  task seed_amfi_data: :environment do
    begin
      #destroy all of previous records
      FundHouse.delete_all
      Scheme.delete_all
      NavDetail.delete_all

      # initialize fund house,schemes and nav_details
      fund_house = FundHouse.create(name: 'Axis Mutual Fund', fundhouse_id: 53, aum: 1022211500000.0)
      schemes = []
      nav_details = []
      nav_details_data = []
      tp = 1
      from_date = Date.parse('01-04-2015').strftime('%d-%b-%Y')
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
        nav_details_data << { scheme_id: scheme.id, nav: data[4].to_f, repurchasing_price: data[5].to_f, sale_price: data[6].to_f, date: data[7], created_at: DateTime.now, updated_at: DateTime.now }
      end
      NavDetail.collection.insert_many(nav_details_data)
    rescue StandardError, SocketError => error
      puts "Error in Execution :- #{error.message}"
    end
  end
end
