module Sigil
  class Base
    attr_reader :params, :key, :signature

    def initialize(params, key)
      raise Sigil::Error, "Params must be a Hash" unless params.kind_of?(Hash)
      @params = params.to_options!
      @key = key.to_s
      @signature = nil
    end

    def to_query
      @params.to_query
    end

    def signature
      unless @signature
        @signature = self.class.sign(self.to_query, @key).to_s
      end
      @signature
    end

    def self.sign(string, key)
      hmacd = OpenSSL::HMAC.new(key, OpenSSL::Digest::SHA1.new)
      hmacd.update(string)
    end

    def verify(provided_signature)
      raise Sigil::Error, "Params not set" if params.empty?
      raise Sigil::Error, "Signature not set" if provided_signature.blank?

      signature == provided_signature
    end
  end
end