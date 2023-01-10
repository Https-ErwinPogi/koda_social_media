class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) if is_navigational_format?
  end
end
