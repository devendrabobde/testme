require 'rails_helper'

describe Devise::OmniauthCallbacksController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
  	@request.env["devise.mapping"]  = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it "As a user, I should be able to sign in with facebook" do
  	get :facebook, format: :html
  	response.status.should == 302
  end

  it "As a user, I should be able to sign in into the system as I already signed in with facebook" do
  	@user = FactoryGirl.create(:user)
  	@authentication = FactoryGirl.create(:authentication, provider: "facebook", uid: "1234", user_id: @user.id)
  	get :facebook, format: :html
  	response.status.should == 302
  end

  it "As a user, I should be able to sign in with facebook If I am already registered with same email" do
  	@user = FactoryGirl.create(:user, email: "johndoe@email.com", password: 12345678, password_confirmation: 12345678)
  	get :facebook, format: :html
  	response.status.should == 302
  end

  it "As a user, I should be able to sign in with google plus" do
  	request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  	get :google_oauth2, format: :html
  	response.status.should == 302
  end

  it "As a user, I should not be able to sign in with google plus if any error encounters" do
  	get :passthru, format: :html, provider: "facebook"
  	response.status.should == 404
  end

end