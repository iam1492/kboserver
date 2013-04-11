class CommentsController < ApiController

  respond_to :json, :xml

  self.responder = ActsAsApi::Responder

  def create
  	@comment = Comment.new(params[:comment])

    if @comment.save
      render :json=>{:success => true, :message=>"success to create comment."}
      return
    else
      render :json=>{:success => false, :message=>"fail to create comment."}
      return  		
    end
  end

  def getComments
    @game_id = params[:game_id]
    @id = params[:id]

    if @id.nil?
      @comments = Comment.getFirstComments(@game_id, 200)
    else
      @comments = Comment.getComments(@game_id, @id, 200)
    end
    
    metadata = {:success => true, :message=>"success to get comments."}
    respond_with(@comments, :api_template => :render_comments, :root => :comments, :meta => metadata)
  end
end
