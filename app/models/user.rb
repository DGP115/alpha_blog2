# frozen_string_literal: true

# Class to model User of Alpha Blog 2


class User < ApplicationRecord
  # Validations

  before_save { self.email_address = email_address.downcase }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { maximum: 100 }

  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false },
                            format: { with: URI::MailTo::EMAIL_REGEXP }

  # Associations
  has_many :articles, dependent: :destroy

  # To use the manual security model provided by bcrypt
  # See https://guides.rubyonrails.org/active_model_basics.html#securepassword
  has_secure_password
end
