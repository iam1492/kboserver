class PitchersController < ApplicationController
  def chart
    pichers = Pitcher.cached_pitchers
    render :json=>{:success => true, :message=>'success to get pitchers rank', :pitcher => pichers}
  end
end
