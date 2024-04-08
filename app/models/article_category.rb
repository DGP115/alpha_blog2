# frozen_string_literal: true

# Class to model many-many-through association between Articles and Categories
class ArticleCategory < ApplicationRecord
  belongs_to :article
  belongs_to :category
end
