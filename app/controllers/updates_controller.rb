class UpdatesController < ApiController
  respond_to :json, :xml

  def create 
  	@update = Update.new(params[:update])

    if @update.save
      render :json=>{:success => true, :message=>"success to create new notice."}
      return
    else
      render :json=>{:success => false, :message=>"fail to create new notice."}
      return  		
    end
  end

  def getLastUpdate
  	@update = Update.getLastUpdate
  	metadata = {:success => true, :message=>"success to get update."}
    respond_with(@update, :api_template => :render_update, :root => :updates, :meta => metadata)
  end
end
