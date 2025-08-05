# frozen_string_literal: true

class AddCategoryTable < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
    end
  end
end
