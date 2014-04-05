class ReportsController < ApiController
  def list

    if (params[:page].eql?'1')
      feed_reports = Report.cached_rank
    elsif (params[:page].eql?'2')
      feed_reports = Report.cached_rank_2
    else
      feed_reports = Report.all.page(params[:page]).order('pub_date DESC')
    end

    if (feed_reports.nil?)
      render :json=>{:success => false, :message=>'fail to get reports.'}
    else
      render :json=>{:success => true, :message=>'success to get reports', :reports => feed_reports}
    end

  end
end
