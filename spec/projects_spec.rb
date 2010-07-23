require 'spec_helper'

describe "Unfuddler::Project" do
  before do
    Unfuddler.authenticate(:username => "John", :password => "", :subdomain => "unfuddler")

    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("projects"), 200)
    end
  end

  describe "find" do
    describe "given no arguments" do
      it "should return an Array" do
        Unfuddler::Project.find.should be_an_instance_of Array
      end

      it "should return an Array with Unfuddler::Project" do
        Unfuddler::Project.find.first.should be_an_instance_of Unfuddler::Project
      end
    end

    describe "given one string argument" do
      it "should return an Array" do
        Unfuddler::Project.find("testproject").should be_an_instance_of Array
      end

      it "should return an Array with Unfuddler::Project objects" do
        Unfuddler::Project.find("testproject").first.should be_an_instance_of Unfuddler::Project
      end

      it "should return Unfuddler::Project objects where the string passed corresponds to the name" do
        Unfuddler::Project.find("testproject").first.short_name.should eql("testproject")
      end
    end

    describe "given a hash argument" do
      it "should return an Array" do
        Unfuddler::Project.find(:id => 2).should be_an_instance_of Array
      end

      it "should return an Array with Unfuddler::Project objects" do
        Unfuddler::Project.find(:id => 2).first.should be_an_instance_of Unfuddler::Project
      end

      it "should return Unfuddler::Project objects where the object should correspond to the attributes specified in the query" do
        Unfuddler::Project.find(:id => 2).first.id.should eql? 2
      end
    end

    # will awesomeify later!

    it "should be able to find right projects using :all, :first and :last" do
      Unfuddler::Project.find(:all).should be_an_instance_of Array
      Unfuddler::Project.find(:all).first.should be_an_instance_of Unfuddler::Project

      Unfuddler::Project.find(:first).should be_an_instance_of Unfuddler::Project
      Unfuddler::Project.find(:first).should eql(Unfuddler::Project.find(:all).first)

      Unfuddler::Project.find(:first)

      Unfuddler::Project.find(:last).should be_an_instance_of Unfuddler::Project
      Unfuddler::Project.find(:last).should eql(Unfuddler::Project.find(:all).first)
    end

    it "should find a project by id when passing a fixnum" do
      Unfuddler::Project.find(2).should be_an_instance_of Array
      Unfuddler::Project.find(2).first.should be_an_instance_of Unfuddler::Project
    end
  end
end
