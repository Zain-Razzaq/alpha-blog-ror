# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user.slice(:id, :name, :email, :admin, :created_at), status: :created
    else
      render json: {
        message: "Invalid email or password"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    # Clear the session to log out the user
    session[:user_id] = nil
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
