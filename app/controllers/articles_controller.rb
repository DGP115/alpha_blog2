# frozen_string_literal: true

# Class for articles controller
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def show; end

  def new
    # Although it doesn't get used [since we create an article instance in the update method]
    # we have to create an object here because the flash message error checking needs an object to check
    @article = Article.new
  end

  def create
    @article = Article.new(whitelist_params)
    if @article.save
      #  Use flash helper to display feedback message
      flash[:notice] = 'Article successfully created'
      redirect_to article_path(@article)
    else
      # The saving of the new article has failed, so:
      # 1:  re-render the new form on which we loop through the
      #     error messages associated with the attempt to save the new article
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(whitelist_params)
      #  Use flash helper to display feedback message
      flash[:notice] = 'Article successfully updated'
      redirect_to articles_path
    else
      # The update of the new article has failed, so:
      # 1:  re-render the new form on which we loop through the
      #     error messages associated with the attempt to save the new article
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @article.delete
      #  Use flash helper to display feedback message
      flash[:notice] = 'Article successfully deleted'
      redirect_to articles_path
    else
      # The deletion of the new article has failed, so:
      # 1:  re-render the show form on which we loop through the
      #     error messages associated with the attempt to save the new article
      # 2:  NOTE:  ", status: :unprocessable_entity" is needed by turbo_streams
      render 'show', status: :unprocessable_entity
    end
  end

  private

  def whitelist_params
    params.require(:article).permit(:title, :description)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
