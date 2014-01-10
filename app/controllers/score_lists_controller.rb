class ScoreListsController < ApplicationController
  def chart
    scores = ScoreList.all
    render :json=>{:success => true, :message=>'success to get score list.', :scores => scores}
  end
end
