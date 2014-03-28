class BattersController < ApiController
  def chart
    batter = Batter.cached_batters
    render :json=>{:success => true, :message=>'fail to create new notice.', :batter => batter}
  end

end
