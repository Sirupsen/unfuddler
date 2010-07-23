require 'spec_helper'

describe "Unfuddler::Ticket" do
  before(:all) do
    Unfuddler.authenticate(:username => "John", :password => "", :subdomain => "unfuddler")

    @project = Unfuddler::Project.new(
      :account_id => 1,
      :archived => false,
      :assignee_on_resolve => "reporter",
      :backup_frequency => 0,
      :close_ticket_simultaneously_default => false, 
      :created_at => "2010-05-20T17:51:57Z",
      :default_ticket_report_id => nil,
      :description => nil,
      :disk_usage => 0, 
      :enable_time_tracking => true,
      :id => 2, 
      :s3_access_key_id => nil, 
      :s3_backup_enabled => false,
      :s3_bucket_name => nil,
      :short_name => "testproject",
      :theme => "blue",
      :ticket_field1_active => false,
      :ticket_field1_disposition => "text",
      :ticket_field1_title => "Field 1",
      :ticket_field2_active => false,
      :ticket_field2_disposition => "text",
      :ticket_field2_title => "Field 2",
      :ticket_field3_active => false,
      :ticket_field3_disposition => "text",
      :ticket_field3_title => "Field 3",
      :title => "Test",
      :updated_at => "2010-06-16T07:28:04Z")

    Unfuddler.stub!(:request).and_return do
      Unfuddler.handle_response(fixture_for("tickets"), 200)
    end
  end

  it "should be able to find all tickets" do
    @project.tickets.should be_an_instance_of Array
    @project.tickets.first.should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to only return one Ticket when using singular" do
    @project.ticket.should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to find tickets by a property" do
    @project.tickets(:id => 212).should be_an_instance_of Array
    @project.tickets(:id => 212).first.should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to a find ticket by property" do
    @project.ticket(:id => 212).should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to find tickets by properties" do
    @project.tickets(:status => "new", :summary => "TestTicket").should be_an_instance_of Array
    @project.tickets(:status => "new", :summary => "TestTicket").first.should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to find a ticket by properties" do
    @project.tickets(:status => "new", :summary => "TestTicket").should be_an_instance_of Array
    @project.tickets(:status => "new", :summary => "TestTicket").first.should be_an_instance_of Unfuddler::Ticket
  end

  it "should be able to find a ticket by id" do
    @project.ticket(212).should be_an_instance_of Unfuddler::Ticket
    @project.ticket(212).id.should eql 212
  end
end

