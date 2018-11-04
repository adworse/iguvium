# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium do
  describe '.read' do
    subject(:pages) { Iguvium.read(path) }

    {
      './spec/files/anna.pdf' => 24,
      './spec/files/remeslo.pdf' => 510,
      './spec/files/quote.pdf' => 2
    }.each do |path, count|
      context path do
        let(:path) { path }

        it { expect(pages.count).to eql(count) }
        it { expect(pages).to all be_a Iguvium::Page }
      end
    end
  end
end
