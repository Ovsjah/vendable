# frozen_string_literal: true

module Vendable
  # Products catalog
  class ProductsBox
    PRODUCTS_AMOUNT = [
      { name: "Lays", price: 2.75, amount: 3 },
      { name: "Cheetos", price: 2.75, amount: 3 },
      { name: "Chio", price: 2.75, amount: 3 },
      { name: "Oreo", price: 1.5, amount: 3 },
      { name: "Kit Kat", price: 1.5, amount: 3 },
      { name: "Tuc", price: 1.5, amount: 3 },
      { name: "Snickers", price: 1.25, amount: 3 },
      { name: "Twix", price: 1.25, amount: 3 },
      { name: "Mars", price: 1.25, amount: 3 }
    ].freeze

    attr_reader :products_amount, :selected_row, :selected_product

    def initialize
      @products_amount = create_products_amount
      @selected_product = nil
      @selected_row = nil
    end

    def catalog
      products_amount.map.with_index do |product_row, index|
        if product_row.empty?
          "#{index} => UNAVAILABLE!"
        else
          "#{index} => #{product_row.first.name} $#{product_row.first.price}"
        end
      end
    end

    def select_row(index)
      @selected_row = products_amount[index]
      @selected_product = products_amount[index].first
    end

    def issue
      product = selected_row.pop
      reset_selection
      product
    end

    def reset_selection
      @selected_row = nil
      @selected_product = nil
    end

    private

    def create_products_amount
      PRODUCTS_AMOUNT.map do |product|
        Array.new(product[:amount], Product.new(product[:name], product[:price]))
      end
    end
  end
end
