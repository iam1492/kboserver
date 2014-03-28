class RanksController < ApiController
  def chart
    #@rank = Rank.all
    @rank = Rank.cached_rank
    render :json=>{:success => true, :message=>'fail to create new notice.', :rank => @rank}
    return
  end

end
