class BoardsController < ApiController
	#respond_to :json, :xml
	#self.responder = ActsAsApi::Responder

	def create
		@board = Board.new(params[:board])

		if @board.save
			render :json=>{:success => true, :result_code => 0, :message=>"success to create board."}
		else
			render :json=>{:success => false, :result_code => 2, :message=>"fail to create board."}
		end
	end

	def update
		@board = Board.find(params[:id])
		@board.update_attributes(params[:board])

		if @board.save
			render :json=>{:success => true, :result_code => 0, :message=>"success to update board."}
		else
			render :json=>{:success => false, :result_code => 2, :message=>"fail to update board."}
		end
	end

	def deleteBoard
		@imei = params[:imei]
		@id = params[:id]

		@developer = 'ekseo00'

		if (!Board.exists?@id)
		  render :json=>{:success => false, :result_code => 2, :message=>"no board found"}
		  return
		end

		@board = Board.find(@id)

		if (@board.nil?)
			render :json=>{:success => false, :result_code => 2, :message=>"no board found"}
			return
		end

		@requestUser = User.getUserInfo(@imei);
		if @requestUser.nil?
			if (!(@imei.eql? @developer))
				render :json=>{:success => false, :result_code => 2, :message=>"no user found"}
				return
			end
		end

		if (@board.imei.eql?(@imei) || @imei.eql?(@developer))
			if(@board.destroy)
				render :json=>{:success => true, :result_code => 0, :message=>"success to delete articles."}
			else
				render :json=>{:success => false, :result_code => 2, :message=>"fails to delete articles"}
			end
		else
			render :json=>{:success => false, :result_code => 1, :message=>"no permission"}
		end

	end

	def destroy
    	@board = Board.find(params[:id])

    	if @board.destroy
      		render :json=>{:success => true,  :result_code => 0, :message=>"success to destroy board."}
      		return
    	else
      		render :json=>{:success => false,  :result_code => 2, :message=>"fail to destroy board."}
      	return      
    	end
  	end

	def add_reply
		@board = Board.find(params[:id])
		@reply = @board.replies.build(:content => params[:content], :imei => params[:imei])
		if @board.save 
		    render :json => {:success => true, :result_code => 0, :reply => @reply, :message => "succeed to create reply"}
		else
		    render :json => {:success => false, :result_code => 2, :reply => @reply.errors, :message => "fail to create reply"}
		end
	end

	def destroy_reply
		@board = Board.find(params[:id])
		@reply = @board.replies.find(params[:reply_id])
		if @board.destroy
		  respond_to do |format|
		    render :json => {:success => true, :result_code => 0, :reply => @reply, :message => "succeed to delete reply"}
		  end
		else
		  respond_to do |format|
		    render :json => {:success => false, :result_code => 2, :reply => @reply.errors, :message => "fail to delete reply"}
		  end
		end
	end

	def getBoards
		@boards = Board.where("board_type=?", params[:board_type]).page(params[:page]).order('created_at DESC')
		logger.debug @boards
		if (@boards.nil?)
			render :json=>{:success => false, :message=>"fail to get boards."}
		else
			metadata = {:success => true, :message=>"success to get boards."}
			respond_with(@boards, :api_template => :board_without_replies, :root => :boards, :meta => metadata)
		end
		
	end

	def getBoardsByLike
		@boards = Board.where("board_type = ?", params[:board_type]).page(params[:page]).order('cached_votes_up DESC')
		if (@boards.nil?)
			render :json=>{:success => false, :message=>"fail to get boards."}
		else
			metadata = {:success => true, :message=>"success to get boards."}
			respond_with(@boards, :api_template => :board_without_replies, :root => :boards, :meta => metadata)
		end
	end

	def show
		@id = params[:id]
		@board = Board.find(@id)
		
		if (@board.nil?)
	      render :json=>{:success => false, :message=>"cannot find board"}
	      return      
	    end
	    metadata = {:success => true, :message=>"success to get replies."}
		respond_with(@board, :api_template => :board_with_replies, :meta => metadata)
	end	

	def vote
	    @id = params[:id]
	    @user = User.getUserInfo(params[:imei])

	    if (@id.nil? || @user.nil?)
	      render :json=>{:success => false, :message=>"id or user is null"}
	      return      
	    end

	    @board = Board.find(@id)

		if (@board.nil?)
	      render :json=>{:success => false, :message=>"cannot find board"}
	      return      
	    end

	    if (@user.voted_up_on? @board)
	    	render :json=>{:success => false, :result_code => 1, :message=>"already vote to board"}
	    	return
	    end
	   
	    if (@board.vote(:voter => @user))
	    	newCount = @board.votes.size
			render :json=>{:success => true, :result_code => 0, :message=>"success to update vote count. current vote #{newCount}"}
		else
			render :json=>{:success => false, :result_code => 2, :message=>"fail to update vote count. current vote #{newCount}"}
		end
  	end

end