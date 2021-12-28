require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /show" do

    let (:user) { create(:user) }
    let (:user_2) { create(:user, username: "user_2", email: "user_2@me.com") }
    let (:admin) { create(:admin_user, username: "admin", email: "admin@me.com") }
    
    context "Normal users" do

      before do
        sign_in(user)
      end

      it "Should show you your own lists" do
        app = create(:application, user: user)
        list = create(:list, application: app)
        get "/#{user.username}/#{app.name}/lists/#{list.name_format}"
        expect(response).to have_http_status(200)
      end

      it "Should not show you other users lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        expect do 
          get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "admin users" do
      before do
        sign_in(admin)
      end

      it "Should allow user admin to see other user lists" do
        app_2 = create(:application, name: "app_2", user: user_2)
        list_2 = create(:list, name: "list 2", application: app_2)
        get "/#{user_2.username}/#{app_2.name}/lists/#{list_2.name_format}"
        expect(response).to have_http_status(200)
      end
    end
  end
end
