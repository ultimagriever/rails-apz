class RecommendationsController < ApplicationController
  before_action :set_article

  # GET /articles/1/recommendation/new
  def new
    @recommendation = Recommendation.new({ article: @article })
  end

  # POST /articles/1/recommendations
  # POST /articles/1/recommendations.json
  def create
    @recommendation = Recommendation.new({
      article: @article,
      email: recommendation_params[:email]
    })

    respond_to do |format|
      if @recommendation.valid? && verify_recaptcha(model: @recommendation) && @recommendation.send?
        format.html { redirect_to articles_url, notice: 'Recommendation was successfully created!'}
        format.json { render json: @recommendation }
      else
        format.html { render :new }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_article
      @article = Article.find(params[:article_id])
    end

    def recommendation_params
      params.require(:recommendation).permit(:email)
    end
end
