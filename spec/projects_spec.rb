require 'spec_helper'

describe "Unfuddler::Project" do
  before(:all) do
    Unfuddler.authenticate(:username => "John", :password => "", :subdomain => "unfuddler")
    headers = {'Content-type' => 'application/xml'}

    @project_id = 117
  end

  it "should be able to load all projects" do
    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("projects"), 200)
    end

    Unfuddler::Project.find.should be_an_instance_of Array
    Unfuddler::Project.find.first.should be_an_instance_of Unfuddler::Project
  end

  it "should be able to find projects by string as name" do
    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("projects"), 200)
    end

    Unfuddler::Project.find("testproject").should be_an_instance_of Array
    Unfuddler::Project.find("testproject").first.should be_an_instance_of Unfuddler::Project
    Unfuddler::Project.find("testproject").first.short_name.should eql("testproject")
  end

  it "should be able to find projects by hash" do
    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("projects"), 200)
    end

    Unfuddler::Project.find(:short_name => "testproject").should be_an_instance_of Array
    Unfuddler::Project.find(:short_name => "testproject").first.should be_an_instance_of Unfuddler::Project
    Unfuddler::Project.find(:short_name => "testproject").first.short_name.should eql("testproject")
  end

  it "should be able to find right projects using :all, :first and :last" do
    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("projects"), 200)
    end

    Unfuddler::Project.find(:all).should be_an_instance_of Array
    Unfuddler::Project.find(:all).first.should be_an_instance_of Unfuddler::Project

    Unfuddler::Project.find(:first).should be_an_instance_of Unfuddler::Project
    Unfuddler::Project.find(:first).should eql(Unfuddler::Project.find(:all).first)

    Unfuddler::Project.find(:last).should be_an_instance_of Unfuddler::Project
    Unfuddler::Project.find(:last).should eql(Unfuddler::Project.find(:all).first)
  end
end
