# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::Page do
  subject(:page) { Iguvium.read(path)[page_index] }

  context 'auction pages' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }
    let(:tables) { page.extract_tables! }

    it { expect(page.text).to be_a String }

    it { expect(page.text.strip).to start_with 'ICANN New gTLD Contention Set Resolution Auction' }

    it '#extract_tables! returns 7 of Iguvium::Table' do
      expect(tables)
        .to have_attributes(count: 7)
        .and all be_a Iguvium::Table
    end
  end

  context 'ip pages' do
    let(:path) { 'spec/files/ip.pdf' }
    let(:page_index) { 1 }
    let(:tables) { page.extract_tables! }

    it { expect(page.text).to be_a String }

    it { expect(page.text.strip).to start_with '19   Наименование территориального органа      Управление' }

    it '#extract_tables! returns 1 of Iguvium::Table' do
      expect(tables)
        .to have_attributes(count: 1)
        .and all be_a Iguvium::Table
    end
  end

  context 'desadaptation pages' do
    let(:path) { 'spec/files/desadaptation.pdf' }
    let(:page_index) { 1 }
    let(:tables) { page.extract_tables! }

    it { expect(page.text).to be_a String }

    it do
      expect(page.text.strip).to start_with(
        "102\n\n\n                                                                     Протокол  результатов    YSQ-S3R"
      )
    end

    it '#extract_tables! returns 1 of Iguvium::Table' do
      expect(tables)
        .to have_attributes(count: 2)
        .and all be_a Iguvium::Table
    end
  end
end
