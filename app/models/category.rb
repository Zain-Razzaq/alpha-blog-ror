# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :blog_categories, dependent: :destroy
  has_many :blogs, through: :blog_categories

  validates :name, presence: true, uniqueness: true
end
