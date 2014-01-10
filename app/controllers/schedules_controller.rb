class SchedulesController < ApiController
  def chart
    schedule = Schedule.all
    render :json=>{:success => true, :message=>'fail to create new notice.', :schedule => schedule}
  end
end
