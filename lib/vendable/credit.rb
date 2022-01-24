# frozen_string_literal: true

module Vendable
  # User credits amount
  class Credit
    attr_reader :amount, :alert

    def initialize(amount = 0)
      @amount = amount
      @alert = nil
    end

    def add(value)
      @amount += value.to_f
    end

    def in_credit?(value)
      in_credit = amount >= value
      @alert = ("Not enough money, insert more, please" unless in_credit)
      in_credit
    end
  end
end
