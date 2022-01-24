# frozen_string_literal: true

require_relative "vendable/version"
require_relative "vendable/product"
require_relative "vendable/products_box"
require_relative "vendable/coin"
require_relative "vendable/coins_box"
require_relative "vendable/credit"
require_relative "vendable/machine"

module Vendable
  class Error < StandardError; end
end
