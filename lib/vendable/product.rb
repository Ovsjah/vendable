# frozen_string_literal: true

module Vendable
  # Products for Vending Machine
  class Product
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end
  end
end
