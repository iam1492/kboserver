class TeamInfosController < ApplicationController
  def chart
    teamInfos = TeamInfo.all
    render :json=>{:success => true, :message=>'success to get team infos.', :teaminfos => teamInfos}
  end
end
