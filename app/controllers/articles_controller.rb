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

	def deleteArticle
		@imei = params[:imei]
		@id = params[:id]

		if (!Article.exists?@id)
		  render :json=>{:success => false, :result_code => 2, :message=>"no article found"}
		  return
		end

		@article = Article.find(@id)
		@requestUser = User.getUserInfo(@imei);

		if (@article.nil?)
			render :json=>{:success => false, :result_code => 2, :message=>"no article found"}
			return
		end

		if (@requestUser.nil?)
			render :json=>{:success => false, :result_code => 2, :message=>"no user found"}
			return
		end

		if (@article.nickname.eql? @requestUser.nickname)
			if(@article.destroy)
				render :json=>{:success => true, :result_code => 0, :message=>"success to delete articles."}
			else
				render :json=>{:success => false, :result_code => 2, :message=>"fails to delete articles"}
			end
		else
			render :json=>{:success => false, :result_code => 1, :message=>"no permission"}
		end

	end

	def deleteAllArticles
		@id = params[:id]
		@password = params[:password]

		Article.delete_all
		render :json=>{:success => true, :message=>"success to delete all articles."}
		return
	end

	def getArticles
		@articles = Article.page(params[:page]).order('created_at DESC')
		if (@articles.nil?)
			render :json=>{:success => false, :message=>"fail to get articles."}
		else
			metadata = {:success => true, :message=>"success to get articles."}
			respond_with(@articles, :api_template => :render_articles, :root => :articles, :meta => metadata)
		end
		
	end

	def getArticlesByLike
		@articles = Article.page(params[:page]).order('cached_votes_up DESC')
		if (@articles.nil?)
			render :json=>{:success => false, :message=>"fail to get articles."}
		else
			metadata = {:success => true, :message=>"success to get articles."}
			respond_with(@articles, :api_template => :render_articles, :root => :articles, :meta => metadata)
		end
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

	    if (@user.voted_up_on? @article)
	    	render :json=>{:success => false, :result_code => 1, :message=>"already vote to article"}
	    	return
	    end
	   
	    if (@article.vote(:voter => @user))
	    	newCount = @article.votes.size
			render :json=>{:success => true, :result_code => 0, :message=>"success to update like count. current like #{newCount}"}
		else
			render :json=>{:success => false, :result_code => 2, :message=>"fail to update like count. current like #{newCount}"}
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
