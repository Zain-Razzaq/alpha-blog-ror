# frozen_string_literal: true

class AddAdminColumnInUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
