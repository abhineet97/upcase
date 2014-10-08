require "rails_helper"

describe Api::V1::StatusesController do
  it "returns a 401 when users are not authenticated" do
    post :create, exercise_uuid: create(:exercise).uuid

    expect(response.code).to eq "401"
  end

  context "#update" do
    it "updates the status of the given exercise for the authenticated user" do
      exercise = create(:exercise)
      user = create(:user)
      access_token = build_stubbed(:oauth_access_token, user: user)
      Doorkeeper::OAuth::Token.stubs(:authenticate).returns(access_token)

      post :create, exercise_uuid: exercise.uuid, state: Status::SUBMITTED

      expect(response).to be_success
      expect(exercise.status_for(user).state).to eq Status::SUBMITTED
    end
  end
end