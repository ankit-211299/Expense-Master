# frozen_string_literal: true

# ApplicationController is the base controller for the application.
class ApplicationController < ActionController::Base
  include ApplicationHelper

  add_flash_types :info, :error, :success

  before_action :set_current_user

  private

  def handle_not_logged_in
    flash[:danger] = 'Please login to access the application.'
    redirect_back(fallback_location: root_path)
  end

  def authenticate_admin
    authenticate_role(true)
  end

  def authenticate_user
    authenticate_role(false)
  end

  def authenticate_role(is_admin)
    return handle_not_logged_in unless Current.user

    if Current.user.is_admin? == is_admin
      update_invalid_route(false)
    else
      update_invalid_route(true)
      redirect_to not_found_path
    end
  end

  def set_current_user
    Current.user = session[:user_id] ? User.find_by(id: session[:user_id]) : nil
  end
end
