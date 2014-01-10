desc 'parse rank data'

task :fetch_score => :environment do
  require 'open-uri'
  require 'nokogiri'
  require 'date'

  strDate = Date.today.strftime('%Y.%m.%d')
  requestUrl = 'http://www.koreabaseball.com/GameCast/GameList.aspx?searchDate=%s' % strDate

  puts requestUrl
  doc = Nokogiri::HTML(open(requestUrl))
  rows = doc.xpath('//div[@id="contents"]/div[@class="smsScore"]')

  details = rows.collect do |row|
    detail = {}
    [
        [:status, 'strong[@class="flag"]/text()'],
        [:home_team, 'p[@class="leftTeam"]/strong[@class="teamT"]/text()'],
        [:home_score, 'p[@class="leftTeam"]/em[@class="score"]/text()'],
        [:away_team, 'p[@class="rightTeam"]/strong[@class="teamT"]/text()'],
        [:away_score, 'p[@class="rightTeam"]/em[@class="score"]/text()'],
        [:station, 'p[@class="place"]/text()'],
        [:start_time, 'p[@class="place"]/span/text()'],
        [:link, 'div[@class="btnSms"]/a[starts-with(@href, "/Schedule/BoxScore.aspx")]/@href']
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
    end
    detail
  end
  puts '============ delete all data ==========='
  ScoreList.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    ScoreList.create!(item)
  end
end

task :fetch_chart => :environment do
	require 'open-uri'
	require 'nokogiri'

	doc = Nokogiri::HTML(open('http://score.sports.media.daum.net/record/baseball/kbo/trnk.daum'))
	rows = doc.xpath('//table[@id="table1"]/tbody/tr')
	
	details = rows.collect do |row|
	  detail = {}
	  [
	    [:rank, 'td[@class="num_rank"]/text()'],
	    [:team, 'td[@class="txt_league"]/a/text()'],
	    [:game_count, 'td[3]/text()'],
	    [:win, 'td[4]/text()'],
	    [:draw, 'td[5]/text()'],
	    [:defeat, 'td[6]/text()'],
	    [:win_rate, 'td[7]/text()'],
	    [:win_diff, 'td[8]/text()'],
	    [:continue, 'td[9]/text()']
	  ].each do |name, xpath|
    	detail[name] = row.at_xpath(xpath).to_s.strip
    end
  		detail
  end
  puts '============= fetch chart ============'

  details.each do |item|
    @rank = Rank.find_by_team(item[:team])
    puts @rank
    @rank.update_attributes(:rank => item[:rank], :game_count => item[:game_count], :win => item[:win],
                           :defeat => item[:defeat], :draw => item[:draw], :win_rate => item[:win_rate],
                           :win_diff => item[:win_diff], :continue => item[:continue])
    if (@rank.save)
      puts 'success to update'
    end
  end
end

task :fetch_batter_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://score.sports.media.daum.net/record/baseball/kbo/brnk.daum'))
  rows = doc.xpath('//table[@id="table1"]/tbody/tr')
  puts '============ start parsing data ==========='
  details = rows.collect do |row|
    detail = {}
    [
        [:rank, 'td[@class="num_rank"]/text()'],
        [:player, 'td[@class="txt_league"]//text()'],
        [:team, 'td[@class="txt_league"]/text()'],
        [:game_count, 'td[3]/text()'],
        [:play_count, 'td[4]/text()'],
        [:bat_count, 'td[5]/text()'],
        [:hit, 'td[6]/text()'],
        [:b2, 'td[7]/text()'],
        [:b3, 'td[8]/text()'],
        [:hr, 'td[9]/text()'],
        [:hit_score, 'td[10]/text()'],
        [:own_score, 'td[11]/text()'],
        [:stolen_base, 'td[12]/text()'],
        [:dead_ball, 'td[13]/text()'],
        [:out_count, 'td[14]/text()'],
        [:heat_rate, 'td[15]/text()'],
        [:run_rate, 'td[16]/text()'],
        [:long_rate, 'td[17]/text()'],
        [:ops, 'td[18]/text()']

    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
    end
    detail
  end

  puts details[0].class
  puts '============ delete all data ==========='
  Batter.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
     Batter.create!(item)
  end
end

task :fetch_schedule => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://score.sports.media.daum.net/schedule/baseball/kbo/main.daum?game_year=2013&game_month=10'))
  rows = doc.xpath('//table[@class="tbl tbl_schedule"]/tbody/tr')
  puts rows.length
  details = rows.collect do |row|
    detail = {}
    [
        [:day, 'td[@class="time_date"]/span[@class="num_time"]/text()'],
        [:weak, 'td[@class="time_date"]/span[@class="txt_day"]/text()'],
        [:home_team, 'td[@class="cont_score"]/a[@class="txt_home"]/text()'],
        [:score, 'span[class=num_score]'],
        [:away_team, 'td[@class="cont_score"]/a[@class="txt_away"]/text()'],
        [:start_time, 'td[@class="cont_time"]/text()'],
        [:tv_info, 'td[@class="cont_info"]/text()'],
        [:station, 'td[@class="cont_area"]/text()'],
        [:no_match, 'td[@class="txt_empty"]/text()']

    ].each do |name, xpath|
        if name.eql?(:no_match)
          no_match = row.at_xpath(xpath).nil?
          if no_match
            detail[name] = false
          else
            detail[name] = true
          end
        elsif name.eql?(:score)
          score = row.css(xpath).text
          scoreArr = score.split(':')
          homeScore = scoreArr[0].nil? ? '' : scoreArr[0]
          awayScore = scoreArr[1].nil? ? '' : scoreArr[1]

          detail['home_score'] = homeScore.strip
          detail['away_score'] = awayScore.strip
        else
          detail[name] = row.at_xpath(xpath).to_s
        end
      end
      detail
  end
  puts details
  puts '============ delete all data ==========='
  Schedule.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    Schedule.create!(item)
  end
end

task :fetch_total_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://sports.media.daum.net/baseball/kbo/record/main.daum'))
  rows = doc.xpath('//ul[@class="player_list"]/li')

  rows.each_with_index do |row, index|
    row.at_xpath()
  end
  details = rows.collect do |row|
    detail = {}
    [
        [:rank, 'td[2]/text()'],
        [:player, 'td[3]/em/a/text()'],
        [:gp, 'td[4]/text()'],
        [:ab, 'td[5]/text()'],
        [:r, 'td[6]/text()'],
        [:hit, 'td[7]/text()'],
        [:b2, 'td[8]/text()'],
        [:b3, 'td[9]/text()'],
        [:hr, 'td[10]/text()'],
        [:rbi, 'td[11]/text()'],
        [:sb, 'td[12]/text()'],
        [:bb, 'td[13]/text()'],
        [:so, 'td[14]/text()'],
        [:avg, 'td[15]/text()'],
        [:slg, 'td[16]/text()'],
        [:obp, 'td[17]/text()'],
        [:ops, 'td[18]/text()']

    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
    end
    detail
  end

  puts details

end
