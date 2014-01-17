class ReportsController < ApiController
  def list
    feed_reports = Report.all.page(params[:page]).order('pub_date DESC')
    logger.debug feed_reports
    if (feed_reports.nil?)
      render :json=>{:success => false, :message=>'fail to get reports.'}
    else
      render :json=>{:success => true, :message=>'success to get reports', :reports => feed_reports}
    end

  end
end
