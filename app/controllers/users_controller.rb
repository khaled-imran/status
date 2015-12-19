class UsersController < ApplicationController

  before_action :authenticate_user!

  def home
    @page_updates = PageUpdate.order(created_at: :desc)
  end

end
