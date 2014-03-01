desc 'parse rank data'

task :fetch_report => :environment do
  require 'open-uri'
  require 'nokogiri'
  require 'feedzirra'
  request_url = "http://rss.donga.com/sportsdonga/baseball.xml"
  request_url2 = "http://mlbspecial.net/rss"
  Report.update_from_feed(request_url)
  Report.update_from_feed(request_url2)
end

task :fetch_score => :environment do
  require 'open-uri'
  require 'nokogiri'
  require 'date'

  strDate = Date.today.strftime('%Y.%m.%d')
  #requestUrl = 'http://www.koreabaseball.com/GameCast/GameList.aspx?searchDate=%s' % strDate

  #test
  requestUrl = 'http://www.koreabaseball.com/GameCast/GameList.aspx?searchDate=2013-10-05'
  doc = Nokogiri::HTML(open(requestUrl))
  rows = doc.xpath('//div[@id="contents"]/div[@class="smsScore"]')
  puts rows.size
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
        [:link, 'div[@class="btnSms"]/a[starts-with(@href, "/Schedule/BoxScore.aspx")]/@href'],
        [:base_url, 'http://www.koreabaseball.com']
    ].each do |name, xpath|
      if name.eql? :base_url
        detail[name] = xpath
      else
        detail[name] = row.at_xpath(xpath).to_s.strip
      end
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

task :fetch_team_info, [:team_num] => :environment do |t, args|
  require 'open-uri'
  require 'nokogiri'
  team_id = args[:team_num]
  requestUrl = 'http://score.sports.media.daum.net/record/baseball/kbo/tinf_main.daum?team_id=%s' % team_id

  doc = Nokogiri::HTML(open(requestUrl))

  rows = doc.xpath('//table[@class="tbl_record tbl_season"]/tbody/tr')

  details = rows.collect do |row|
    detail = {}
    [
        [:total_score, 'td[7]/text()'],
        [:total_loss, 'td[8]/text()'],
        [:total_avg, 'td[9]/text()'],
        [:total_hit, 'td[10]/text()'],
        [:total_hr, 'td[11]/text()'],
        [:total_rb, 'td[12]/text()'],
        [:total_outcout, 'td[13]/text()'],
        [:total_failure, 'td[15]/text()'],
        [:team_id, '']
    ].each do |name, xpath|
      if name.eql?(:team_id)
        detail[name] = team_id.to_i
      elsif name.eql?(:total_avg)
        strValue = row.at_xpath(xpath).to_s.strip
        detail[name] = strValue.to_f
      else
        strValue = row.at_xpath(xpath).to_s.strip
        detail[name] = strValue.to_i
      end
    end
    detail
  end
  puts details[0]

  teamInfo = TeamInfo.find_or_initialize_by_team_id(details[0][:team_id])
  teamInfo.update_attributes(details[0])

  #puts '============ delete all data ==========='
  #Rank.delete_all
  #
  #puts '============ insert new data ==========='
  #details.each do |item|
  #  Rank.create!(item)
  #end

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
      [:defeat, 'td[6]/text()'],
	    [:draw, 'td[5]/text()'],
	    [:win_rate, 'td[7]/text()'],
	    [:win_diff, 'td[8]/text()'],
	    [:win_continue, 'td[9]/text()'],
      [:recent_game, 'td[9]/text()']
	  ].each do |name, xpath|
    	detail[name] = row.at_xpath(xpath).to_s.strip
    end
  		detail
  end
  puts details
  puts '============ delete all data ==========='
  Rank.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    Rank.create!(item)
  end
end

task :fetch_pitcher_total_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://www.koreabaseball.com/Record/PitcherTop5.aspx'))
  rows = doc.xpath('//div[@class="top5"]/div/ol[@class="rankList"]')
  details = []
  rows.each_with_index do |row, index|
    innerRows = row.xpath('li')
    players = ''
    values = ''
    detail = {}
    innerRows.each_with_index do |innerRow, innerIndex|

      players += innerRow.at_xpath('a/text()').to_s.strip
      values += innerRow.at_xpath('span/text()').to_s.strip

      if (innerIndex < innerRows.length - 1)
        players += ','
        values += ','
      end
    end
    detail['category'] = index
    detail['players'] = players
    detail['values'] = values
    details << detail
  end

  puts '============ delete all data ==========='
  TotalRank.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    TotalRank.create!(item)
  end
end

task :fetch_batter_total_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://www.koreabaseball.com/Record/HitterTop5.aspx'))
  rows = doc.xpath('//div[@class="top5"]/div/ol[@class="rankList"]')
  details = []
  rows.each_with_index do |row, index|
    innerRows = row.xpath('li')
    players = ''
    values = ''
    detail = {}
    innerRows.each_with_index do |innerRow, innerIndex|

      players += innerRow.at_xpath('a/text()').to_s.strip
      values += innerRow.at_xpath('span/text()').to_s.strip

      if (innerIndex < innerRows.length - 1)
        players += ','
        values += ','
      end
    end

    detail['profile_img'] = row.at_xpath('../p/img/@src').to_s.strip
    detail['category'] = index
    detail['players'] = players
    detail['values'] = values
    details << detail
  end
  puts details

  puts '============ delete all data ==========='
  TotalHitterRank.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    TotalHitterRank.create!(item)
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

  doc = Nokogiri::HTML(open('http://score.sports.media.daum.net/schedule/baseball/kbo/main.daum?game_year=2013&game_month=09'))
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
        [:no_match, 'td[@class="txt_empty"]/text()'],
        [:game_relay_url, ''],
        [:game_record_url,'td[@class="cont_cast"]/span[@class="wrap_btn"]/a[@class="btn_comm btn_result"]/@href'],
        [:is_canceled, 'td[@class="cont_score"]/span[@class="ico_comm3 ico_cancel"]/text()']
    ].each do |name, xpath|
        if name.eql?(:no_match)  || name.eql?(:is_canceled)
          has_field = !row.at_xpath(xpath).nil?
          if has_field
            detail[name] = true
          else
            detail[name] = false
          end
        elsif name.eql?(:score)
          score = row.css(xpath).text
          scoreArr = score.split(':')
          homeScore = scoreArr[0].nil? ? '' : scoreArr[0]
          awayScore = scoreArr[1].nil? ? '' : scoreArr[1]

          detail['home_score'] = homeScore.strip
          detail['away_score'] = awayScore.strip
        elsif name.eql?(:game_relay_url)
          xpath_text = 'td[@class="cont_cast"]/span[@class="wrap_btn"]/a[@class="btn_comm btn_text"]/@href'
          xpath_cast = 'td[@class="cont_cast"]/span[@class="wrap_btn"]/a[@class="btn_comm btn_caster"]/@href'

          value_text = row.at_xpath(xpath_text).to_s
          value_cast = row.at_xpath(xpath_cast).to_s

          if (value_text.length != 0)
            detail[name] = value_text
          else
            detail[name] = value_cast
          end
        else
          detail[name] = row.at_xpath(xpath).to_s
        end
      end
      detail
  end
  #puts details
  puts '============ delete all data ==========='
    Schedule.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    Schedule.create!(item)
  end
end

#task :fetch_total_rank => :environment do
#  require 'open-uri'
#  require 'nokogiri'
#
#  doc = Nokogiri::HTML(open('http://sports.media.daum.net/baseball/kbo/record/main.daum'))
#  rows = doc.xpath('//ul[@class="player_list"]/li')
#
#  rows.each_with_index do |row, index|
#    row.at_xpath()
#  end
#  details = rows.collect do |row|
#    detail = {}
#    [
#        [:rank, 'td[2]/text()'],
#        [:player, 'td[3]/em/a/text()'],
#        [:gp, 'td[4]/text()'],
#        [:ab, 'td[5]/text()'],
#        [:r, 'td[6]/text()'],
#        [:hit, 'td[7]/text()'],
#        [:b2, 'td[8]/text()'],
#        [:b3, 'td[9]/text()'],
#        [:hr, 'td[10]/text()'],
#        [:rbi, 'td[11]/text()'],
#        [:sb, 'td[12]/text()'],
#        [:bb, 'td[13]/text()'],
#        [:so, 'td[14]/text()'],
#        [:avg, 'td[15]/text()'],
#        [:slg, 'td[16]/text()'],
#        [:obp, 'td[17]/text()'],
#        [:ops, 'td[18]/text()']
#
#    ].each do |name, xpath|
#      detail[name] = row.at_xpath(xpath).to_s.strip
#    end
#    detail
#  end
#
#  puts details
#
#end
