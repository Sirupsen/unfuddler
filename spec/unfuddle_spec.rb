require 'spec_helper'

describe Unfuddler do
  it "should be able to authenticate" do
    Unfuddler.authenticate(:username => "John", :password => "seekrit", :subdomain => "unfuddler")

    Unfuddler.authenticated?.should be_true
  end

  describe "authentication values" do
    it "should have the subdomain set to Unfuddler" do
      Unfuddler.subdomain.should == "unfuddler"
    end

    it "should have the username set to John" do
      Unfuddler.username.should == "John"
    end

    it "should have the password set to Seekrit" do
      Unfuddler.password.should == "seekrit"
    end
  end

  describe "helpers" do
    describe "finder" do
      before(:all) do
        @objects = []
        @objects << Hashie::Mash.new({:id => 1, :name => "Bob"})
        @objects << Hashie::Mash.new({:id => 2, :name => "John"})
      end

      it "should return only one object in this case" do
        Unfuddler.finder(@objects, {:id => 1, :name => "Bob"}).should have(1).objects
      end

      it "should return the right object" do
        Unfuddler.finder(@objects, {:id => 1, :name => "Bob"}).first.name.should == "Bob"
      end
    end
  end
end
