# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium do
  describe '.read' do
    context 'anna.pdf' do
      let(:pages) { Iguvium.read('./spec/files/anna.pdf') }

      it 'returns 24 Iguvium::Page' do
        expect(pages.count).to eql(24)
        expect(pages).to all be_a Iguvium::Page
      end
    end

    context 'remeslo.pdf' do
      let(:pages) { Iguvium.read('./spec/files/remeslo.pdf') }

      it 'returns 510 Iguvium::Page' do
        expect(pages.count).to eql(510)
        expect(pages).to all be_a Iguvium::Page
      end
    end

    context 'immunity.pdf' do
      let(:pages) { Iguvium.read('./spec/files/immunity.pdf') }

      it 'returns 78 Iguvium::Page' do
        expect(pages.count).to eql(78)
        expect(pages).to all be_a Iguvium::Page
      end
    end
  end
end
