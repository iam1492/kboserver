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
end
