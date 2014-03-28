class TotalHitterRanksController < ApplicationController
  def chart
    ranks = TotalHitterRank.cached_total_hitters
    render :json=>{:success => true, :message=>'success to get total ranks.', :total_hitter_ranks => ranks}
  end
end
