class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session #:exception
  # before_action :authenticate_user!
end
