require 'rspec'

RSpec.describe Iguvium::Page do
  subject(:page) { Iguvium.read(path)[page_index] }
  
  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }

    it '#text returns a String' do
      expect(page.text).to be_a String
    end

    it '#text starts with \'ICANN New gTLD Contention Set Resolution Auction\'' do
      expect(page.text.strip.start_with? 'ICANN New gTLD Contention Set Resolution Auction').to be true
    end

    context '#extract_tables!' do

    end
  end
end