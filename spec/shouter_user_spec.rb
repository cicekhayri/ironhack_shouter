require_relative '../shouter'
require_relative 'spec_helper'

I18n.enforce_available_locales = false

describe User do
  before do
    @user = User.new
    @user.name = "Hayri Cicek"
    @user.handle = "cicekhayri"
    @user.password = "pass123word2k3j3k3j3"
  end

  it "should get '/'" do
    get '/'
    last_response.should be_ok
  end

  it "should create new user" do
    get '/new_user'
    last_response.should be_ok
  end
  
  describe "users name" do
    it "should require name" do
      @user.name = nil
      @user.valid?.should be_falsy
    end
  end

  describe "users handler" do 
    it "should be unique user name" do
      @user.handle = "cicek"
      @user.valid?.should be_truthy
    end

    it "should not include spaces in the user name" do
      @user.handle = "cicekhayri"
      @user.valid?.should_not eql("c icek hayr i")
    end
  end

  describe "users password" do
    it "have to be password" do
      @user.password = nil
      @user.valid?.should be_falsy
    end

    it "should have a length of 8 characters or more" do
      @user.password = "pass"
      @user.valid?.should be_falsy
    end
  end

  #it "should require user name" do
  #  blank = User.new(:name => "")
  #  blank.should_not be_valid
  #  blank.errors[:name].should include("can't be blank")

  #  blank.name = "cicekhayri"
  #  blank.should be_valid
  #end
end
