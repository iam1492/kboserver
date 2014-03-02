class PitchersController < ApplicationController
  def chart
    pichers = Pitcher.all
    render :json=>{:success => true, :message=>'success to get pitchers rank', :pitcher => pichers}
  end
end
