class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private
    def after_sign_in_path_for(resource)
      sign_out resource unless current_user.active?
      home_path
    end
end
