require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Signify::Base do

  before :each do
    @params = { :cutlery => "knife", "fruit" => :apple }
    @key = "deadbeef"
    @signify = Signify::Base.new(@params, @key)
    @signature = "e8a8f0ba2d3be6ec3965e0d7b6f9daf690972f3a"
  end

  describe "initialization" do

    it "should require params to be set and of type Hash" do
      lambda { Signify::Base.new(HashWithIndifferentAccess.new, "deadbeef") }.should_not raise_error
      lambda { Signify::Base.new("banana", "deadbeef") }.should raise_error
    end

    it "should convert the key to a string" do
      signify = Signify::Base.new({}, 123)
      signify.send(:key).should == "123"
    end

    it "should symbolify params" do
      @signify.params.should == { :cutlery => "knife", :fruit => :apple }
    end

  end

  describe "signature generation" do

    it "should convert the params to a query string" do
      @signify.to_query.should == "cutlery=knife&fruit=apple"
    end

    it "should sign the query string with the provided key" do
      @signify.signature.should == @signature
    end

    it "should return the same signature when called more than once" do
      @signify.signature.should == @signature
      @signify.signature.should == @signature
    end

  end

  describe "signing" do

    it "should return the key as as HMAC object" do
      Signify::Base.sign("lorem ipsum", @key).should be_a_kind_of(OpenSSL::HMAC)
    end

    it "should sign a string with a key" do
      Signify::Base.sign("lorem ipsum", @key).to_s.should == "372b097876a405c2c5ceef96ca6eecea623ff649"
    end

  end

  describe "input verification convenience methods" do

    it "should verify against a provided signature" do
      @signify.verify(@signature).should == true
    end

    it "should verify against a wrong signature" do
      @signify.verify("abc").should == false
    end

    it "should raise an error if no params present" do
      signify = Signify::Base.new({}, @key)
      lambda { signify.verify("abc") }.should raise_error(Signify::Error, /Params not set/)
    end

    it "should raise an error if no signature specified" do
      signify = Signify::Base.new(@params, @key)
      lambda { signify.verify("") }.should raise_error(Signify::Error, /Signature not set/)
    end

  end

end