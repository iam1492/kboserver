class SchedulesController < ApiController
  require 'nokogiri'
  require 'open-uri'

  def chart
    schedule = Schedule.all
    render :json=>{:success => true, :message=>'fail to create new notice.', :schedule => schedule}
  end

  def chart_by_date

    year = params[:year]
    month = params[:month]
    url = 'http://score.sports.media.daum.net/schedule/baseball/kbo/main.daum?game_year=%s&game_month=%s' % [year, month]
    doc = Nokogiri::HTML(open(url))
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

    render :json=>{:success => true, :message=>'success to get schedule.', :schedule => details}
  end
end
