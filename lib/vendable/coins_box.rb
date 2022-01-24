# frozen_string_literal: true

module Vendable
  # Coins Box that stores coins in Vending Machine
  class CoinsBox
    SUPPORTED_COINS = %w[0.25 0.5 1 2 3 5].freeze

    COINS_AMOUNT = [
      { value: "0.25", amount: 3 },
      { value: "0.5", amount: 3 },
      { value: "1", amount: 3 },
      { value: "2", amount: 3 },
      { value: "3", amount: 3 },
      { value: "5", amount: 3 }
    ].freeze

    attr_reader :coins_amount, :values_cache, :alert

    def initialize
      @coins_amount = create_coins_amount
      @values_cache = []
      @alert = nil
    end

    def add(coin)
      return coin unless SUPPORTED_COINS.include?(coin.value)

      values_cache << coin.value
      coins_amount << coin
      reset_alert
    end

    def exact_change?
      exact_change = coins_amount.count { |coin| coin.value == SUPPORTED_COINS[0] } <= 2 ||
                     coins_amount.count { |coin| coin.value == SUPPORTED_COINS[1] }.zero?
      @alert = ("Exact change only!" if exact_change)
      exact_change
    end

    def get_change(amount, position = -1, change = [])
      current_coin_value = SUPPORTED_COINS[position]
      return rollback(change) unless current_coin_value
      return change unless amount.positive?

      result = amount - current_coin_value.to_f

      if result.negative? || total_count(current_coin_value).zero?
        get_change(amount, position - 1, change)
      else
        change << remove(current_coin_value)

        get_change(result, position, change)
      end
    end

    def drop_coins
      values_cache.map { |value| remove(value) }
    end

    def present(coins)
      info = ""
      change_counted = coins.each_with_object(Hash.new(0)) { |coin, result| result[coin.value] += 1 }
      change_counted.each { |value, count| info += " 'Coin #{value}' * #{count};" }
      info.strip
    end

    def reset_cache
      @values_cache = []
    end

    private

    def rollback(change)
      @alert = "Sorry. Not enough change"
      coins_amount << change.pop until change.empty?
      drop_coins
    end

    def reset_alert
      @alert = nil
    end

    def total_count(value)
      coins_amount.count { |coin| coin.value == value }
    end

    def remove(value)
      coins_amount.delete_at(coins_amount.index { |coin| coin.value == value })
    end

    def create_coins_amount
      COINS_AMOUNT.map { |coin| Array.new(coin[:amount], Coin.new(coin[:value])) }.flatten
    end
  end
end
