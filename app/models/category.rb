# frozen_string_literal: true

# Class to model Category(s) of Articles of Alpha Blog 2
class Category < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 3, maximum: 20 }

  # Associations
  has_many :article_categories
  has_many :articles, through: :article_categories
end
