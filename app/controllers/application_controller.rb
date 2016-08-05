class ApplicationController < ActionController::Base
  protect_from_forgery expect: :sign_in, with: :exception, prepend: true
  # before_action :authenticate_user!
end
