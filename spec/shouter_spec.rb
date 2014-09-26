require_relative '../shouter'
require_relative 'spec_helper'
require 'date'

I18n.enforce_available_locales = false

describe Shout do
  
  before do
    @shout = Shout.new
    @shout.message = "This is sooooooooooooo cooooooooool"
    @shout.created_at = Date.today
    @shout.likes = 1
  end
  
  describe "shout message" do 
    it "should have at least 1 character" do
      @shout.message = nil
      @shout.valid?.should be_falsy
    end
  
    it "should have maximum of 200 characters" do
      @shout.message = "haodhoishfosdhfodshfodshfoidhfoihfds dohfaoshfodahfdihsaf oo dhifaos sdoh dsohfds ofhdsoioshfosdhfoidshfs fosdihfd ofhds fosdh fodsihf dsoifh dsifh dsoihf dsofds hfdsohf dso sd fodsoh fdsoih dsosoh dssodfoidsh foih fiodsh foisdhdoishfoihsdfoihdsiohf dsofh dsoifh ds dshds fsdo fdiosfh dsofho fhosi dfodsf odsi fdosfhds fodsh fiodshfh"
      @shout.valid?.should be_falsy
    end
    
    it "should have created date present" do
      @shout.created_at = Date.today
      @shout.valid?.should be_truthy
    end

    it "set the likes counter to numericality" do
      @shout.likes = "string"
      @shout.valid?.should be_falsy
    end
  end
end
