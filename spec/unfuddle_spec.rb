require 'spec_helper'

describe "Unfuddler" do
  it "should be able to instance and authenticate" do
    Unfuddler.authenticate(:username => "John", :password => "", :subdomain => "unfuddler")

    Unfuddler.subdomain.should eql "unfuddler"
    Unfuddler.username.should eql "John"
    Unfuddler.password.should eql ""

    Unfuddler.authenticated?.should be_true
  end
end
