require 'spec_helper'

describe Unfuddler do
  it "should be able to authenticate" do
    Unfuddler.authenticate(:username => "John", :password => "seekrit", :subdomain => "unfuddler")

  Unfuddler.authenticated?.should be_true
  end

  describe "authentication values" do
    it "should have the subdomain set correctly" do
      Unfuddler.subdomain.should == "unfuddler"
    end

    it "should have the username set correctly" do
      Unfuddler.username.should == "John"
    end

    it "should have the password set correctly" do
      Unfuddler.password.should == "seekrit"
    end
  end
end
