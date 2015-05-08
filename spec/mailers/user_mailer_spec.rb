require 'rails_helper'

describe UserMailer do
  describe "#account_confirmed" do
	it "I should be able to confirm my account by clicking on confirmation link from email" do
	  @user = FactoryGirl.create(:user)
	  @email = UserMailer.account_confirmed(@user)      
	  @email.should deliver_to("#{@user.email}")
	  @email.should have_subject(/Account successfully confirmed!./)
	end
  end
end