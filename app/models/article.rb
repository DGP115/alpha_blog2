# frozen_string_literal: true

# Class to model Artcile of Alpha Blog 2
class Article < ApplicationRecord
  # Add constraints
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
end
