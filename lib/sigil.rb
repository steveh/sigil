require "active_support/core_ext/hash"
require "active_support/core_ext/object/conversions"
require "openssl"

module Sigil
  class Error < StandardError; end
end

require "sigil/base"