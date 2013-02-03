require 'spec_helper'

describe UsersController do

  describe "admin users" do
    let(:admin) { create(:admin) }

    # sign in (without Capybara)
    before { request.cookies[:remember_token] = admin.remember_token }

    describe "DELETE destroy themselves" do
      before { delete :destroy, id: admin.id }
      specify { response.should redirect_to(root_path) }
    end
  end

  describe "non admin users" do
    let(:user) { create(:user_location_stubbed) }

    describe "signed-in users" do
      before { request.cookies[:remember_token] = user.remember_token }

      describe "trying to act on other users" do
        let(:other_user) { create(:user) }

        describe "DELETE destroy not themselves" do
          before { delete :destroy, id: other_user.id }
          specify { response.should redirect_to(root_path) }
        end

        describe "PUT update not themselves" do
          before { put :update, id: other_user.id }
          specify { response.should redirect_to(root_path) }
        end
      end

      describe "POST create themselves" do
        before { post :create, user_id: user.id }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "PUT update non-signed-in users" do
      before { put :update, id: user.id }
      specify { response.should redirect_to(new_session_path) }
    end
  end

end
