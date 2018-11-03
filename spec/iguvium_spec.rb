# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium do
  describe '.read' do
    context 'anna.pdf' do
      it 'returns array of 24' do
        expect(Iguvium.read('./spec/files/anna.pdf').count).to eql(24)
      end

      it 'elements of array are of class Iguvium::Page' do
        expect(Iguvium.read('./spec/files/anna.pdf').all? { |page| page.is_a?(Iguvium::Page) }).to be true
      end
    end

    context 'remeslo.pdf' do
      it 'returns array of 510' do
        expect(Iguvium.read('./spec/files/remeslo.pdf').count).to eql(510)
      end

      it 'elements of array are of class Iguvium::Page' do
        expect(Iguvium.read('./spec/files/remeslo.pdf').all? { |page| page.is_a?(Iguvium::Page) }).to be true
      end
    end

    context 'immunity.pdf' do
      it 'returns array of 78' do
        expect(Iguvium.read('./spec/files/remeslo.pdf').count).to eql(78)
      end

      it 'elements of array are of class Iguvium::Page' do
        expect(Iguvium.read('./spec/files/remeslo.pdf').all? { |page| page.is_a?(Iguvium::Page) }).to be true
      end
    end
  end
end
