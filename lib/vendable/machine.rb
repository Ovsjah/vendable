# frozen_string_literal: true

module Vendable
  # Vending Machine
  class Machine
    attr_reader :credit, :coins_box, :products_box, :selected

    def initialize
      @credit = Credit.new
      @coins_box = CoinsBox.new
      @products_box = ProductsBox.new
    end

    def menu
      products_box.catalog
    end

    def insert_coin(value)
      puts coins_box.alert if coins_box.exact_change?

      declined_coin = coins_box.add(Coin.new(value))
      return declined_coin if declined_coin

      credit.add(value)
    end

    def select_product(index)
      products_box.select_row(index)
      return unless products_box.selected_product

      unless credit.in_credit?(products_box.selected_product.price)
        products_box.reset_selection
        return credit.alert
      end

      process_order
    end

    def cancel
      coins = coins_box.drop_coins
      coins_box.present(coins)
      reset_vending
      coins
    end

    private

    def process_order
      coins = process_change(products_box.selected_product.price)
      reset_vending

      if coins_box.alert
        puts coins_box.alert
        products_box.reset_selection
        return coins
      end

      [products_box.issue, coins].compact
    end

    def process_change(price)
      coins = coins_box.get_change(credit.amount - price)
      puts coins_box.present(coins)
      coins
    end

    def reset_vending
      @credit = Credit.new
      coins_box.reset_cache
    end
  end
end
