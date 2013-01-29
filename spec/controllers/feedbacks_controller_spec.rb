require 'spec_helper'

describe FeedbacksController do
  let(:user) { create(:user) }

  describe "POST create" do
    before { post :create, user_id: user.id }
    specify { response.should redirect_to(signin_path) }
  end

  describe "DELETE destroy" do
    let(:feedback) { create(:feedback) }
    before { delete :destroy, id: feedback.id, user_id: user.id }
    specify { response.should redirect_to(signin_path) }
  end
end
