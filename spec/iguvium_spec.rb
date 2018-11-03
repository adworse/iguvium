# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium do
  describe '.read' do
    context 'anna.pdf' do
      let(:pages) { Iguvium.read('./spec/files/anna.pdf') }

      it 'returns 24 elements' do
        expect(pages.count).to eql(24)
      end

      it 'elements are Iguvium::Page' do
        expect(pages).to all be_a Iguvium::Page
      end
    end

    context 'remeslo.pdf' do
      let(:pages) { Iguvium.read('./spec/files/remeslo.pdf') }

      it 'returns 510 elements' do
        expect(pages.count).to eql(510)
      end

      it 'elements are Iguvium::Page' do
        expect(pages).to all be_a Iguvium::Page
      end

    end

    context 'immunity.pdf' do
      let(:pages) { Iguvium.read('./spec/files/immunity.pdf') }

      it 'returns 78 elements' do
        expect(pages.count).to eql(78)
      end

      it 'elements are Iguvium::Page' do
        expect(pages).to all be_a Iguvium::Page
      end
    end
  end
end
