require 'spec_helper'

describe "Bmc" do

  before :all do
    @path = '/usr/local/bin'
    @provider = "freeipmi"
    @user = "ipmiuser"
    @pass = "impipass"
    @host = "ipmihost"
  end

 before :each do


    Rubyipmi.stub(:locate_command).with('ipmipower').and_return("#{@path}/ipmipower")

    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true})


  end

  it "connection should not be nil" do
    @conn.should_not be_nil
  end

  it "fru should not be nil" do
    @conn.fru.should_not be_nil
  end

  it "provider should not be nil" do
    @conn.provider.should_not be_nil
  end

  it "provider should be freeipmi" do
    @conn.provider.should == "freeipmi"
  end

  it "bmc should not be nil" do
    @conn.bmc.should_not be_nil
  end

  it "sensors should not be nil" do
    @conn.sensors.should_not be_nil

  end

  it "chassis should not be nill" do
    @conn.chassis.should_not be_nil

  end

  it 'object should have debug set to true' do
    @conn.debug.should eq true
  end

  it 'object should have driver set to auto if not specified' do
    @conn.options.has_key?('driver-type').should eq false
  end

  it 'object should have driver set to auto if not specified' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'auto'})
    @conn.options.has_key?('driver-type').should eq false
  end

  it 'object should have priv type set to ADMINISTRATOR if not specified' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'auto'})
    @conn.options.has_key?('privilege-level').should eq false
  end

  it 'object should have priv type set to USER ' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:privilege => 'USER', :debug => true, :driver => 'auto'})
    @conn.options.fetch('privilege-level').should eq('USER')
  end

  it 'should raise exception if invalid privilege type' do
    expect{Rubyipmi.connect(@user, @pass, @host, @provider,{:privilege => 'BLAH',:debug => true, :driver => 'auto'})}.to raise_error(RuntimeError)
  end

  it 'should raise exception if invalid driver type' do
    expect{Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'foo'})}.to raise_error(RuntimeError)
  end

  it 'object should have driver set to lan_2_0' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'lan20'})
    @conn.options['driver-type'].should eq('LAN_2_0')
  end

  it 'object should have driver set to lan' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'lan15'})
    @conn.options['driver-type'].should eq('LAN')
  end

  it 'object should have driver set to openipmi' do
    @conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'open'})
    @conn.options['driver-type'].should eq('OPENIPMI')
  end

  describe 'test' do
    it 'should retrun boolean on test connection when result is not a hash' do
      conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'auto'})
      bmc = double()
      allow(bmc).to receive(:info).and_return('')
      allow(conn).to receive(:bmc).and_return(bmc)
      expect(conn.connection_works?).to eq false
    end

    it 'should retrun boolean on test connection when result is a hash' do
      conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'auto'})
      bmc = double()
      allow(bmc).to receive(:info).and_return({:test => true})
      allow(conn).to receive(:bmc).and_return(bmc)
      expect(conn.connection_works?).to eq true
    end

    it 'should retrun boolean on test connection when nil' do
      conn = Rubyipmi.connect(@user, @pass, @host, @provider,{:debug => true, :driver => 'auto'})
      bmc = double()
      allow(bmc).to receive(:info).and_return(nil)
      allow(conn).to receive(:bmc).and_return(bmc)
      expect(conn.connection_works?).to eq false
    end
  end
end