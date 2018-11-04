# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::Page do
  subject(:page) { Iguvium.read(path)[page_index] }

  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }
    let(:tables) { page.extract_tables! }

    it { expect(page.text).to be_a String }

    it { expect(page.text.strip).to start_with 'ICANN New gTLD Contention Set Resolution Auction' }

    it '#extract_tables! returns 7 Iguvium::Table with 2nd tested' do
      expect(tables.count).to eql(7)
      expect(tables).to all be_a Iguvium::Table
      expect(tables[2].to_a).to eql(
        [
          ['String Won', 'Applicant', 'Application ID', 'Winning Price', 'Date of Auction'],
          ['HOTELS', 'Booking.com B.V.', '1-1016-75482', '$2,200,000', '18-Nov-2015']
        ]
      )
      expect(tables[2].to_csv).to eql(
        "String Won,Applicant,Application ID,Winning Price,Date of Auction\nHOTELS,Booking.com B.V.,1-1016-75482,\"$2,200,000\",18-Nov-2015\n"
      )
    end
  end
end
