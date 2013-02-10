class ArticlesController < ApplicationController
	respond_to :json, :xml
	self.responder = ActsAsApi::Responder

	def create
		@article = Article.new(params[:article])

		if @article.save
			render :json=>{:success => true, :message=>"success to create article."}
			return
		else
			render :json=>{:success => false, :message=>"fail to create article."}
			return  		
		end
	end

	def getArticles

		@id = params[:id]

		if @id.nil?
			@articles = Article.getFirstArticles(20)
		else
			@articles = Article.getMoreArticles(@id, 20)
		end
		#should add has_more attribute
		#if (@articles.id > Article.)
		metadata = {:success => true, :message=>"success to get articles."}
		respond_with(@articles, :api_template => :render_articles, :root => :articles, :meta => metadata)
	end

	def getArticlesByLike

		@id = params[:id]

		if @id.nil?
			@articles = Article.getFirstArticlesByLike(20)
		else
			@articles = Article.getMoreArticlesByLike(@id, 20)
		end
		#should add has_more attribute
		#if (@articles.id > Article.)
		metadata = {:success => true, :message=>"success to get articles."}
		respond_with(@articles, :api_template => :render_articles, :root => :articles, :meta => metadata)
	end

	def alert
	    @id = params[:id]

	    if (@id.nil?)
	      render :json=>{:success => false, :message=>"id is null"}
	      return      
	    end

	    @article = Article.find(@id)

		if (@article.nil?)
	      render :json=>{:success => false, :message=>"cannot find article"}
	      return      
	    end

	    newCount = @article.alert_count + 1

	    if (@article.update_attributes(:alert_count => newCount))
	      render :json=>{:success => true, :message=>"success to update like count. current like #{newCount}"}
	      return
	    else
	      render :json=>{:success => false, :message=>"fail to update like count. current like #{newCount}"}
	      return      
	    end
  	end

	def vote
	    @id = params[:id]
	    @user = User.getUserInfo(params[:imei])

	    if (@id.nil? || @user.nil?)
	      render :json=>{:success => false, :message=>"id or user is null"}
	      return      
	    end

	    @article = Article.find(@id)

		if (@article.nil?)
	      render :json=>{:success => false, :message=>"cannot find article"}
	      return      
	    end
	   
	    if (@article.vote(:voter => @user))
	    	newCount = @article.votes.size
			render :json=>{:success => true, :message=>"success to update like count. current like #{newCount}"}
		else
			render :json=>{:success => false, :message=>"fail to update like count. current like #{newCount}"}
		end

  	end

	def like
	    @id = params[:id]

	    if (@id.nil?)
	      render :json=>{:success => false, :message=>"id is null"}
	      return      
	    end

	    @article = Article.find(@id)

		if (@article.nil?)
	      render :json=>{:success => false, :message=>"cannot find article"}
	      return      
	    end

	    newCount = @article.like + 1

	    if (@article.update_attributes(:like => newCount))
	      render :json=>{:success => true, :message=>"success to update like count. current like #{newCount}"}
	      return
	    else
	      render :json=>{:success => false, :message=>"fail to update like count. current like #{newCount}"}
	      return      
	    end
  	end
end
