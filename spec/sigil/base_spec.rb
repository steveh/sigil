require "spec_helper"

describe Sigil::Base do

  before :each do
    @params = { :cutlery => "knife", "fruit" => :apple }
    @key = "deadbeef"
    @sigil = Sigil::Base.new(@params, @key)
    @signature = "e8a8f0ba2d3be6ec3965e0d7b6f9daf690972f3a"
  end

  describe "initialization" do

    it "should require params to be set and of type Hash" do
      lambda { Sigil::Base.new(HashWithIndifferentAccess.new, "deadbeef") }.should_not raise_error
      lambda { Sigil::Base.new("banana", "deadbeef") }.should raise_error
    end

    it "should convert the key to a string" do
      sigil = Sigil::Base.new({}, 123)
      sigil.send(:key).should == "123"
    end

    it "should symbolify params" do
      @sigil.params.should == { :cutlery => "knife", :fruit => :apple }
    end

  end

  describe "signature generation" do

    it "should convert the params to a query string" do
      @sigil.to_query.should == "cutlery=knife&fruit=apple"
    end

    it "should sign the query string with the provided key" do
      @sigil.signature.should == @signature
    end

    it "should return the same signature when called more than once" do
      @sigil.signature.should == @signature
      @sigil.signature.should == @signature
    end

  end

  describe "signing" do

    it "should return the key as as HMAC object" do
      Sigil::Base.sign("lorem ipsum", @key).should be_a_kind_of(OpenSSL::HMAC)
    end

    it "should sign a string with a key" do
      Sigil::Base.sign("lorem ipsum", @key).to_s.should == "372b097876a405c2c5ceef96ca6eecea623ff649"
    end

  end

  describe "input verification convenience methods" do

    it "should verify against a provided signature" do
      @sigil.verify(@signature).should be_true
      @sigil.verify!(@signature).should be_true
    end

    it "should verify against a wrong signature" do
      @sigil.verify("abc").should be_false
      lambda { @sigil.verify!("abc") }.should raise_error(Sigil::Error, /Signature does not match/)
    end

    it "should raise an error if no params present" do
      sigil = Sigil::Base.new({}, @key)
      sigil.verify("abc").should be_false
      lambda { sigil.verify!("abc") }.should raise_error(Sigil::Error, /Params not set/)
    end

    it "should raise an error if no signature specified" do
      sigil = Sigil::Base.new(@params, @key)
      sigil.verify("").should be_false
      lambda { sigil.verify!("") }.should raise_error(Sigil::Error, /Signature not set/)
    end

  end

end
