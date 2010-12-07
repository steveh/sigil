require "active_support/core_ext/hash"
require "active_support/core_ext/object/conversions"
require "openssl"

module Signify
  class Error < StandardError; end
end

require "signify/base"