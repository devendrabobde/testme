require 'rails_helper'

describe User do

  describe "Users table should have following fields present in DB" do    
    it { should have_db_column(:active_flag).of_type(:boolean) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }    
    it { should have_db_column(:confirmation_token).of_type(:string) }
    it { should have_db_column(:confirmed_at).of_type(:datetime) }
    it { should have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { should have_db_column(:unconfirmed_email).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:delete_flag).of_type(:boolean) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe "A user should not be able to register without following attributes" do
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
  end

  describe "User should allow email with validated format" do
    it { should_not allow_value("john").for(:email) }
    it { should allow_value("john@mailinator.com").for(:email) }
  end

  it "A user should be able to have multiple authentications like Facebook and Google" do
    t = User.reflect_on_association(:authentications)
    t.macro.should == :has_many
  end

  describe "Each user should belong to a plan" do
    it {should belong_to(:plan)}
  end

end