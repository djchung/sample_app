# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.valid?.should_not == true

  end

  it"should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.valid?.should_not == true
  end

  it "should accept valid email addresses" do
    addresses = %w(user@foo.com THE_USER@foo.bar.org first.last@foo.jp)
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.valid? == true
    end
  end

  it "should reject invalid email address" do
    addresses = %w(user@foo,com user_at_foo.org example.user@foo.)
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.valid?.should_not == true
    end
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.valid?.should_not == true
  end

  it "should reject duplicate email addresses" do
    # Put a user with already used email address into database
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.valid?.should_not == true
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.valid?.should_not == true

  end

end
