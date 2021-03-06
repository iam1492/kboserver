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
  requestUrl = 'http://www.koreabaseball.com/GameCast/GameList.aspx?searchDate=%s' % strDate

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
#
#task :fetch_score2 => :environment do
#  require 'open-uri'
#  require 'nokogiri'
#  require 'date'
#
#  strDate = Date.today.strftime('%Y.%m.%d')
#  #requestUrl = 'http://www.koreabaseball.com/GameCast/GameList.aspx?searchDate=%s' % strDate
#
#  #test
#  requestUrl = 'http://score.sports.media.daum.net/schedule/baseball/kbo/main.daum'
#  doc = Nokogiri::HTML(open(requestUrl))
#  rows = doc.xpath('//table[@class="tbl tbl_schedule"]/tbody/tr[ends-with(@class,'today')]')
#  #rows = doc.xpath('//table[@class="tbl tbl_schedule"]/tbody/tr')
#  puts rows.size
#  details = rows.collect do |row|
#    detail = {}
#    [
#        [:status, 'td[@class="cont_score"]/span[@class="ico_comm3 ico_ing"]/text()'],
#        [:home_team, 'td[@class="cont_score"]/a[@class="txt_home"]/text()'],
#        [:home_score, 'td[@class="cont_score"]/span[@class="num_score"]/text()'],
#        [:away_team, 'td[@class="cont_score"]/a[@class="txt_away"]/text()'],
#        [:home_score, 'td[@class="cont_score"]/span[@class="num_score"]/text()'],
#        [:station, 'td[@class="cont_area"]/text()'],
#        [:start_time, 'td[@class="cont_time"]/text()'],
#        [:link, 'td[@class="cont_cast"]/a[@class="btn_comm btn_preview"]/@href'],
#        [:base_url, 'http://score.sports.media.daum.net']
#    ].each do |name, xpath|
#      if name.eql? :base_url
#        detail[name] = xpath
#      else
#        detail[name] = row.at_xpath(xpath).to_s.strip
#      end
#    end
#    detail
#  end
#  puts details
#  #puts '============ delete all data ==========='
#  #ScoreList.delete_all
#  #
#  #puts '============ insert new data ==========='
#  #details.each do |item|
#  #  ScoreList.create!(item)
#  #end
#end

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

  if !details[0].nil?

    team_id = details[0][:team_id]
    should_update = false

    case team_id
      when 382..390
        should_update = true
      when 172615
        should_update = true
      when 394601
        should_update = true
    end

    if should_update
      teamInfo = TeamInfo.find_or_initialize_by_team_id(details[0][:team_id])
      result = teamInfo.update_attributes(details[0])
      puts 'update=' + result.to_s
    end
  end
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
      [:team_id, 'td[@class="txt_league"]/a/@href'],
	    [:game_count, 'td[3]/text()'],
	    [:win, 'td[4]/text()'],
      [:defeat, 'td[6]/text()'],
	    [:draw, 'td[5]/text()'],
	    [:win_rate, 'td[7]/text()'],
	    [:win_diff, 'td[8]/text()'],
	    [:win_continue, 'td[9]/text()'],
      [:recent_game, 'td[9]/text()']
	  ].each do |name, xpath|
      if name.eql?(:team_id)
        player_team = row.at_xpath(xpath).to_s.strip
        detail[name] = player_team.match(/team_id=(\d+)/)[1]
      else
    	  detail[name] = row.at_xpath(xpath).to_s.strip
      end
    end
  		detail
  end

  puts details.length
  details.each do |detail|
    rank = Rank.find_or_initialize_by_team_id(detail[:team_id])
    rank.update_attributes(detail)
  end

  #if (details.size == 0)
  #  details = [{:rank => 1, :team => '두산', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => '넥센', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => 'LG', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => 'NC', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => '삼성', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => '한화', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => 'SK', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => '기아', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'},
  #             {:rank => 1, :team => '롯데', :game_count => '0', :win => '0', :defeat => '0', :draw => '0', :win_rate => '0', :win_diff => '0', :win_continue => '0', :recent_game => '0'}]
  #end
  #puts '============ delete all data ==========='
  #Rank.delete_all
  #puts '============ insert new data ==========='
  #details.each do |item|
  #  Rank.create!(item)
  #end
end

task :init_rank => :environment do
  Rank.delete_all
end

task :new_total_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://www.koreabaseball.com/Record/Main.aspx'))
  rows = doc.xpath('//div[@class="record_list"]')

  hitters = []

  rows.each_with_index do |row, index|
    innerRows = row.xpath("div[contains(concat(' ', @class, ' '), ' record ')]")
    innerRows += row.xpath("div/div[contains(concat(' ', @class, ' '), ' record ')]")
    # innerRows = row.xpath('div/div[@class="list"]/div/ol[@class="rankList"]')

    #타자 
    if index == 0
      details = []
      innerRows.each_with_index do |row, index|
        detail = {}
        players = ''
        values = ''
        
        lastRows = row.xpath('div[@class="list"]/div[@class="player_top5"]/ol/li')
        lastRows.each_with_index do |item, item_idx|
          players += (item.at_xpath('span/a/text()').to_s.strip + '(' + item.at_xpath('span[@class="team"]/text()').to_s.strip + ')')
          values += item.at_xpath('span[@class="rr"]/text()').to_s.strip
          if (item_idx < lastRows.length - 1)
            players += ','
            values += ','
          end
        end
        
        detail['profile_img'] = lastRows.at_xpath('../../../div/img/@src').to_s.strip
        detail['profile_img'].slice! 'http://www.koreabaseball.com/'
        
        case index
          when 3 then detail['category'] = 7
          when 4 then detail['category'] = 3
          when 5 then detail['category'] = 4
          when 9 then detail['category'] = 5
          when 10 then detail['category'] = 6
          when 6,7,8,11,12,13,14 then next
          else detail['category'] = index
        end
        detail['players'] = players
        detail['values'] = values
        details << detail
      end
      puts '============ delete all data ==========='
      TotalHitterRank.delete_all

      puts '============ insert new data ==========='
      details.each do |item|
        TotalHitterRank.create!(item)
      end
    end

    #투수
    if index == 1
      details = []
      innerRows.each_with_index do |row, index|
        detail = {}
        players = ''
        values = ''
        
        lastRows = row.xpath('div[@class="list"]/div[@class="player_top5"]/ol/li')
        lastRows.each_with_index do |item, item_idx|
          players += (item.at_xpath('span/a/text()').to_s.strip + '(' + item.at_xpath('span[@class="team"]/text()').to_s.strip + ')')
          values += item.at_xpath('span[@class="rr"]/text()').to_s.strip
          if (item_idx < lastRows.length - 1)
            players += ','
            values += ','
          end
        end
        
        detail['profile_img'] = lastRows.at_xpath('../../../div/img/@src').to_s.strip
        detail['profile_img'].slice! 'http://www.koreabaseball.com/'

        case index
          when 5 then detail['category'] = 3
          when 6 then detail['category'] = 4
          when 9 then detail['category'] = 5          
          when 3,4,7,8,10,11,12,13,14 then next
          else detail['category'] = index
        end
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
    detail['profile_img'] = row.at_xpath('../p/img/@src').to_s.strip
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
        [:team, 'td[@class="txt_league"]//text()'],
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
      if name.eql?(:player)
        player_team = row.at_xpath(xpath).to_s.strip
        detail[name] = player_team.split.first
      elsif name.eql?(:team)
        player_team = row.at_xpath(xpath).to_s.strip
        detail[name] = player_team.match(/\((.*)\)/)[1]
      else
        detail[name] = row.at_xpath(xpath).to_s.strip
      end
    end

    detail
  end
  #puts details
  puts '============ delete all data ==========='
  Batter.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
     Batter.create!(item)
  end
end

task :fetch_pitcher_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://score.sports.media.daum.net/record/baseball/kbo/prnk.daum'))
  rows = doc.xpath('//table[@id="table1"]/tbody/tr')

  puts '============ start parsing data ==========='
  details = rows.collect do |row|
    detail = {}
    [
        [:rank, 'td[@class="num_rank"]/text()'],
        [:player, 'td[@class="txt_league"]//text()'],
        [:team, 'td[@class="txt_league"]//text()'],
        [:game_count, 'td[3]/text()'],
        [:win, 'td[4]/text()'],
        [:lose, 'td[5]/text()'],
        [:save_point, 'td[6]/text()'],
        [:hold, 'td[7]/text()'],
        [:inning, 'td[8]/text()'],
        [:ball_count, 'td[9]/text()'],
        [:hit_count, 'td[10]/text()'],
        [:hr_count, 'td[11]/text()'],
        [:out_count, 'td[12]/text()'],
        [:dead_ball, 'td[13]/text()'],
        [:total_lost_score, 'td[14]/text()'],
        [:lost_score, 'td[15]/text()'],
        [:avg_lost_score, 'td[16]/text()'],
        [:whip, 'td[17]/text()'],
        [:qs, 'td[18]/text()']

    ].each do |name, xpath|
      if name.eql?(:player)
        player_team = row.at_xpath(xpath).to_s.strip
        detail[name] = player_team.split.first
      elsif name.eql?(:team)
        player_team = row.at_xpath(xpath).to_s.strip
        detail[name] = player_team.match(/\((.*)\)/)[1]
      else
        detail[name] = row.at_xpath(xpath).to_s.strip
      end
    end

    detail
  end
  puts '============ delete all data ==========='
  Pitcher.delete_all

  puts '============ insert new data ==========='
  details.each do |item|
    Pitcher.create!(item)
  end
end

task :fetch_schedule => :environment do
  require 'open-uri'
  require 'nokogiri'

  #year = params[:year]
  #month = params[:month]
  url = 'http://score.sports.media.daum.net/schedule/baseball/kbo/main.daum?game_year=2014&game_month=03'
  doc = Nokogiri::HTML(open(url))
  rows = doc.xpath('//table[@class="tbl tbl_schedule tbl_country"]/tbody/tr')
  puts rows.length
  details = rows.collect do |row|
    detail = {}
    [
        [:day, 'td[@class="time_date"]/text()'],
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
  #puts '============ delete all data ==========='
  #  Schedule.delete_all
  #
  #puts '============ insert new data ==========='
  #details.each do |item|
  #  Schedule.create!(item)
  #end
end

