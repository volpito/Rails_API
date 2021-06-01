class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    @articles = Article.all

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    if authenticate_user!
      if @article.save
        @article.user_id = current_user.id if current_user
        render json: @article, status: :created, location: @article
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /articles/1
  def update
    if current_user == @article.user
      if @article.update(article_params)
        render json: @article
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /articles/1
  def destroy
    if current_user == @article.user
      @article.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content)
    end
end
