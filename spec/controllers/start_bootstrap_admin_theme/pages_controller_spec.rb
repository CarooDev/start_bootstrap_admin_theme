require 'rails_helper'

module StartBootstrapAdminTheme
  RSpec.describe PagesController, type: :controller do
    routes { Engine.routes }

    describe "GET #show" do
      it "renders the template matching the id" do
        get :show, params: { id: 'index.html' }

        expect(response).to have_http_status(:success)
      end
    end
  end
end
