# frozen_string_literal: true

RSpec.describe Vendable::ProductsBox do
  subject { described_class.new }

  describe "#catalog" do
    context "with available products" do
      let(:expected_result) do
        [
          "0 => Lays $2.75", "1 => Cheetos $2.75", "2 => Chio $2.75",
          "3 => Oreo $1.5", "4 => Kit Kat $1.5", "5 => Tuc $1.5",
          "6 => Snickers $1.25", "7 => Twix $1.25", "8 => Mars $1.25"
        ]
      end

      it "presents products rows with corresponding index" do
        expect(subject.catalog).to eq(expected_result)
      end
    end

    context "with unavailable products" do
      let(:expected_result) do
        [
          "0 => Lays $2.75", "1 => Cheetos $2.75", "2 => Chio $2.75",
          "3 => Oreo $1.5", "4 => Kit Kat $1.5", "5 => Tuc $1.5",
          "6 => Snickers $1.25", "7 => Twix $1.25", "8 => UNAVAILABLE!"
        ]
      end
      before(:each) { subject.products_amount[-1] = [] }

      it "presents unavailable products as UNAVAILABLE" do
        expect(subject.catalog).to eq(expected_result)
      end
    end
  end

  describe "#issue" do
    before(:each) { subject.select_row(7) }

    it { expect(subject.issue).to eq(subject.products_amount[7].last) }

    it "resets selection" do
      expect(subject).to receive(:reset_selection)
      subject.issue
    end
  end
end
