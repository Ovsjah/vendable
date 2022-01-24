# frozen_string_literal: true

module Vendable
  # Coin for Vending Machine
  class Coin
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end
