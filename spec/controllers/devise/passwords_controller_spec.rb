require 'rails_helper'

describe Devise::PasswordsController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user.confirm!
  end

  describe "GET 'new'" do
    it "I should be able to see form to send reset password instruction using an email" do
      get :new, format: :html
      response.should be_success
    end    
  end

  describe "POST 'create'" do
    it "I should be able to send reset password instruction on COA's email" do
      post :create, format: :html, user: { email: @user.email }
      response.status.should == 302
    end
    it "I should be able to see en error validation message if the email is not registered with system" do
      post :create, format: :html, user: { email: "josh@malinator.com" }
      response.status.should == 200
    end
  end

  describe "GET 'edit'" do
    it "I should be able to see for for edit reset password" do
      @user.send_reset_password_instructions
      get :edit, format: :html, reset_password_token: @user.reset_password_token
      response.status.should == 200
    end
    it "I should be able to see error validation message if the reset password token sent time is invalid" do
      @user.send_reset_password_instructions
      @user.update_attributes(reset_password_sent_at: (Time.now-2.day))
      get :edit, format: :html, reset_password_token: @user.reset_password_token
      response.status.should == 302
    end
    it "I should be able to see error validation message if the reset password token is invalid" do
      get :edit, format: :html, reset_password_token: @user.reset_password_token
      response.status.should == 302
    end    
  end

  describe "PUT 'update'" do
    it "I should be able to update the password using reset password token" do
      @user.send_reset_password_instructions
      put :update, format: :html, user: { reset_password_token: @user.reset_password_token, password: "password@1234", password_confirmation: "password@1234" }
      response.status.should == 302
    end
    it "I should be able to see error validation message while updating the password using invalid reset password token" do
      @user.send_reset_password_instructions
      put :update, format: :html, user: { reset_password_token: @user.reset_password_token, password: "password@1234", password_confirmation: "password@1234" }
      response.status.should == 302
    end
    it "I should be able to see error validation message while updating the password if the reset password token is expired" do
      @user.send_reset_password_instructions
      @user.update_attributes(reset_password_sent_at: (Time.now-2.day))
      put :update, format: :html, user: { reset_password_token: @user.reset_password_token, password: "password@1234", password_confirmation: "password@1234" }
      response.status.should == 200
    end
  end

end