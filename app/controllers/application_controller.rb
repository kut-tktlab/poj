class ApplicationController < ActionController::Base
  add_breadcrumb 'ホーム', '/'
  protect_from_forgery with: :exception
end
