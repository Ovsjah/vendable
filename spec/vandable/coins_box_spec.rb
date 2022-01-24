# frozen_string_literal: true

RSpec.describe Vendable::CoinsBox do
  subject { described_class.new }

  let(:coin_025) { Vendable::Coin.new("0.25") }
  let(:coin_05) { Vendable::Coin.new("0.5") }
  let(:coin_1) { Vendable::Coin.new("1") }

  describe "#add" do
    context "with valid coins" do
      it "adds coins" do
        expect { subject.add(coin_025) }.to change { subject.coins_amount.size }.by(1)
      end

      it "caches coin value" do
        subject.add(coin_1)
        expect(subject.values_cache).to include(coin_1.value)
      end

      it "resets alert" do
        expect(subject).to receive(:reset_alert)
        subject.add(coin_05)
      end
    end

    context "with invalid coins" do
      let(:coin) { Vendable::Coin.new("0.75") }

      it "returns coin" do
        expect(subject.add(coin)).to eq(coin)
      end

      it "doesn't add coins" do
        expect { subject.add(coin) }.not_to change(subject, :coins_amount)
      end
    end
  end

  describe "#exact_change?" do
    it { expect(subject.exact_change?).to be false }
    it "doesn't set alert" do
      subject.exact_change?
      expect(subject.alert).to be_nil
    end

    context "with exact change" do
      before(:each) { subject.coins_amount.delete_if { |coin| coin.value == "0.25" } }

      it "returns true if exact change" do
        expect(subject.exact_change?).to be true
      end

      it "sets alert" do
        subject.exact_change?
        expect(subject.alert).not_to be_nil
      end
    end
  end

  describe "#get_change" do
    let(:amount) { 4.75 }

    context "with sufficient coins amount" do
      let(:change_values) { ["3", "1", "0.5", "0.25"] }

      it "returns change" do
        expect(subject.get_change(amount).map(&:value)).to eq(change_values)
      end
    end

    context "with unavailable coins" do
      let(:change_values) { ["2", "2", "0.5", "0.25"] }

      before(:each) { subject.coins_amount.delete_if { |coin| coin.value == "3" } }

      it "returns change" do
        expect(subject.get_change(amount).map(&:value)).to eq(change_values)
      end
    end

    context "with insufficient coins amount" do
      let(:amount) { 2.75 }
      let(:change_values) { %w[2 2] }

      before(:each) do
        subject.coins_amount.delete_if { |coin| coin.value == "0.25" || coin.value == "2" }
        change_values.each { |value| subject.add(Vendable::Coin.new(value)) }
      end

      it "calls rollback" do
        expect(subject).to receive(:rollback)
        subject.get_change(amount)
      end

      it "returns inserted coins" do
        expect(subject.get_change(amount).map(&:value)).to eq(change_values)
      end
    end
  end

  describe "#rollback" do
    let(:coins_change) { [coin_1, coin_05, coin_025] }

    it "sets alert" do
      subject.send(:rollback, coins_change)
      expect(subject.alert).not_to be_nil
    end

    it "changes coins amount" do
      expect { subject.send(:rollback, coins_change) }.to change { subject.coins_amount.size }.by(3)
    end

    it "removes change" do
      subject.send(:rollback, coins_change)
      expect(coins_change).to be_empty
    end

    it "drops coins" do
      expect(subject).to receive(:drop_coins)
      subject.send(:rollback, coins_change)
    end
  end

  describe "#drop_coins" do
    let(:dropped_values) { ["0.25", "0.5", "1"] }
    before(:each) do
      subject.add(coin_025)
      subject.add(coin_05)
      subject.add(coin_1)
    end

    it "drops coins" do
      expect(subject.drop_coins.map(&:value)).to eq(dropped_values)
    end
  end

  describe "#present" do
    let(:change) { [coin_1, coin_1, coin_05, coin_025, coin_025] }
    let(:presentation) { "'Coin 1' * 2; 'Coin 0.5' * 1; 'Coin 0.25' * 2;" }

    it "presents coins" do
      expect(subject.present(change)).to eq(presentation)
    end
  end
end
