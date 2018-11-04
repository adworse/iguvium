# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::Table do
  subject(:table) { Iguvium.read(path)[page_index].extract_tables![table_index] }

  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }
    let(:table_index) { 2 }

    it {
      expect(table.to_a).to eql(
        [
          ['String Won', 'Applicant', 'Application ID', 'Winning Price', 'Date of Auction'],
          ['HOTELS', 'Booking.com B.V.', '1-1016-75482', '$2,200,000', '18-Nov-2015']
        ]
      )
      expect(table.to_csv).to eql(
        "String Won,Applicant,Application ID,Winning Price,Date of Auction\nHOTELS,Booking.com B.V.,1-1016-75482,\"$2,200,000\",18-Nov-2015\n"
      )
    }
  end
end
