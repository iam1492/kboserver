desc "parse rank data"

task :fetch_rank => :environment do
	require 'open-uri'
	require 'nokogiri'
	# Perform naver baseball rank
	doc = Nokogiri::HTML(open('http://sports.news.naver.com/schedule/index.nhn?category=kbo'))
	aHomeTeam = doc.css('.team_lft')
	aAwayTeam = doc.css('.team_rgt')
	aScore = doc.css('.td_score')
	
	count = aHomeTeam.length	

	for i in (0).upto(count - 1)
		h = aHomeTeam[i].text
		a = aAwayTeam[i].text
		s = aScore[i].text

   		puts "#{h} #{s} #{a}"
	end
end

task :fetch_chart => :environment do
	require 'open-uri'
	require 'nokogiri'

	doc = Nokogiri::HTML(open('http://sports.media.daum.net/baseball/kbo/record/main.daum'))
	rows = doc.xpath('//table[@class="tbl main_season_kbo"]/tbody/tr')
	
	details = rows.collect do |row|
	  detail = {}
	  [
	    [:rank, 'td[1]/text()'],
	    [:team, 'td[2]/a/text()'],
	    [:game_count, 'td[3]/text()'],
	    [:win, 'td[4]/text()'],
	    [:defeat, 'td[5]/text()'],
	    [:draw, 'td[6]/text()'],
	    [:win_rate, 'td[7]/text()'],
	    [:win_diff, 'td[8]/text()'],
	    [:continue, 'td[9]/text()'],
	    [:recent_game, 'td[10]/text()']
	  ].each do |name, xpath|
    	detail[name] = row.at_xpath(xpath).to_s.strip
  		end
  		detail
	end
  #puts details
  #puts details[0].class

  details.each do |item|
    @rank = Rank.find_by_team(item[:team])
    puts @rank
    @rank.update_attributes(:rank => item[:rank], :game_count => item[:game_count], :win => item[:win],
                           :defeat => item[:defeat], :draw => item[:draw], :win_rate => item[:win_rate],
                           :win_diff => item[:win_diff], :continue => item[:continue], :recent_game => item[:recent_game])
    if (@rank.save)
      puts 'success to update'
    end
  end
end



task :fetch_batter_rank => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://sports.media.daum.net/baseball/kbo/record/brnk_bysn.daum'))
  rows = doc.xpath('//table[@class="tbl batter_season"]/tbody/tr')

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

task :fetch_test => :environment do
  require 'open-uri'
  require 'nokogiri'

  doc = Nokogiri::HTML(open('http://sports.media.daum.net/baseball/kbo/schedule/main.daum?game_year=2013&game_month=10'))
  rows = doc.xpath('//table[@class="record_calendar_list"]/tbody/tr')
  puts rows.length
  details = rows.collect do |row|
    detail = {}
    [
        [:date, 'td[@class="date"]/text()'],
        [:team1, 'td[@class="team1"]/a/text()'],
        [:team1_score, 'td[@class="team1"]/em/text()'],
        [:team2, 'td[@class="team2"]/a/text()'],
        [:team2_score, 'td[@class="team2"]/em/text()'],
        [:time, 'td[@class="time"]/text()'],
        [:tv, 'td[@class="tv"]/text()'],
        [:stadium, 'td[@class="stadium"]/text()'],
        [:no_match, 'td[@class="no_match"]/text()']
    ].each do |name, xpath|
        if name.eql?(:no_match)
          no_match = row.at_xpath(xpath).nil?
          if no_match
            detail[name] = true
          else
            detail[name] = false
          end
        else
          detail[name] = row.at_xpath(xpath).to_s.strip
        end
      end
      detail
  end
  puts details
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
