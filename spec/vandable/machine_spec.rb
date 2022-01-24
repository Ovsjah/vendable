# frozen_string_literal: true

RSpec.describe Vendable::Machine do
  subject { described_class.new }

  let(:products_row) { subject.products_box.products_amount[7] }

  describe "#menu" do
    it "lists catalog" do
      expect(subject.products_box).to receive(:catalog)
      subject.menu
    end
  end

  describe "#insert_coin" do
    context "with valid coin" do
      it "adds credits" do
        expect(subject.credit).to receive(:add)
        subject.insert_coin("5")
      end
    end

    context "with invalid coin" do
      it "returns coin" do
        expect(subject.insert_coin("invalid")).to be_kind_of(Vendable::Coin)
      end
    end
  end

  describe "#select_product" do
    after(:each) { subject.select_product(7) }

    context "with sufficient credits" do
      before(:each) { subject.insert_coin("5") }

      it "processes product row" do
        expect(subject).to receive(:process_order)
      end
    end

    context "with insufficient credits" do
      it "resets selection" do
        expect(subject.products_box).to receive(:reset_selection)
      end

      it "return credit alert" do
        expect(subject.credit).to receive(:alert)
      end

      it "doesn't process order" do
        expect(subject).not_to receive(:process_order)
      end
    end

    context "with unavailable products" do
      before(:each) { subject.products_box.products_amount[7] = [] }

      it "doesn't process order" do
        expect(subject).not_to receive(:process_order)
      end
    end
  end

  describe "#cancel" do
    before(:each) { subject.insert_coin("3") }

    it "returns inserted coins" do
      expect(subject.cancel).to all(be_kind_of(Vendable::Coin))
    end

    it "presents returned coins" do
      expect(subject.coins_box).to receive(:present)
      subject.cancel
    end

    it "resets vending" do
      expect(subject).to receive(:reset_vending)
      subject.cancel
    end
  end

  describe "#process order" do
    before(:each) { subject.insert_coin("5") }

    it "issues product" do
      expect(subject.products_box).to receive(:issue)
      subject.select_product(7)
    end

    it "process change" do
      expect(subject).to receive(:process_change)
      subject.select_product(7)
    end

    it "resets vending" do
      expect(subject).to receive(:reset_vending)
      subject.select_product(7)
    end

    it "returns product" do
      expect(subject.select_product(7).first).to be_kind_of(Vendable::Product)
    end

    it "returns coins" do
      expect(subject.select_product(7).last.map(&:value)).to eq(["3", "0.5", "0.25"])
    end

    context "with coins box alert" do
      before(:each) { subject.coins_box.coins_amount.delete_if { |coin| coin.value == "0.25" } }

      it "returns coins" do
        expect(subject.select_product(7).map(&:value)).to eq(["5"])
      end

      it "doesn't issue product" do
        expect(subject.products_box).not_to receive(:issue)
        subject.select_product(7)
      end
    end
  end
end
