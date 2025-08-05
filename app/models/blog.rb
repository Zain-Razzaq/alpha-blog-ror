# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :blog_categories, dependent: :destroy
  has_many :categories, through: :blog_categories
  
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }
end
