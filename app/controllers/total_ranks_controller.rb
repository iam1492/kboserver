class TotalRanksController < ApplicationController
  def chart
    ranks = TotalRank.cached_total
    render :json=>{:success => true, :message=>'success to get total ranks.', :total_ranks => ranks}
  end
end
