module StartBootstrapAdminTheme
  class PagesController < ApplicationController
    def show
      render params[:id], layout: false
    end
  end
end
