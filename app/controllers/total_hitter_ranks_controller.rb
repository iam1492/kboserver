class TotalHitterRanksController < ApplicationController
  def chart
    ranks = TotalHitterRank.all
    render :json=>{:success => true, :message=>'success to get total ranks.', :total_hitter_ranks => ranks}
  end
end
