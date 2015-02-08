class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_game
  before_action :authorize, only: [:edit, :update, :destroy]

  private
    def find_game
      @game = Game.find_by_id(params[:game_id]) || Game.current
    end
    def authorize
      redirect_to request.referrer unless current_user
    end
    def current_user
      true
    end
    def current_admin
      true
    end
end
