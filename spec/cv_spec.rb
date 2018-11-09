# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::CV do
  subject(:cv) { Iguvium::CV.new(Iguvium::Image.read(path, page_index + 1, images: true, gspath: gspath)) }

  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }

    let(:gspath) do
      return 'gs' unless RbConfig::CONFIG['host_os'].match?(/mswin|mingw|cygwin/)
      gspath = Dir.glob('C:/Program Files/gs/gs*/bin/gswin??c.exe').first.tr('/', '\\')
      "\"#{gspath}\""
    end


    let(:lines) { cv.recognize[:lines]}
    let(:boxes) { cv.recognize[:boxes]}

    it do
      expect(boxes)
        .to have_attributes(count: 7)
        .and eql(
          [
            [64..536, 326..427], [70..188, 434..439], [64..536, 476..536], [70..138, 542..547],
            [64..536, 578..610], [70..121, 617..622], [70..133, 669..721]
          ]
        )

      expect(lines[:vertical])
        .to have_attributes(count: 24)
        .and eql(
          [
            [66, 326..427], [253, 326..426], [440, 326..426], [160, 327..426], [347, 327..426],
            [534, 328..425], [74, 434..439], [534, 476..536], [66, 477..536], [222, 477..535],
            [378, 477..535], [74, 542..547], [66, 578..610], [534, 578..608], [253, 579..610],
            [440, 579..610], [160, 580..609], [347, 580..609], [74, 617..622], [81, 669..680],
            [122, 670..675], [108, 675..682], [88, 696..711], [116, 696..711]
          ]
        )
      expect(lines[:horizontal])
        .to have_attributes(count: 25)
        .and eql(
          [
            [64..533, 328], [65..535, 342], [65..536, 356], [65..536, 370], [65..536, 384],
            [65..536, 398], [64..536, 425], [70..188, 436], [64..532, 478], [65..534, 492],
            [65..535, 506], [64..536, 534], [70..138, 545], [66..532, 580], [65..534, 594],
            [64..535, 608], [70..120, 620], [107..124, 676], [79..84, 677], [70..78, 681],
            [84..133, 683], [103..108, 690], [79..86, 694], [78..86, 701], [95..108, 718]
          ]
        )
    end
  end

  context 'quote' do
    let(:path) { 'spec/files/quote.pdf' }
    let(:page_index) { 0 }

    let(:lines) { cv.recognize[:lines]}
    let(:boxes) { cv.recognize[:boxes]}

    it do
      expect(boxes)
        .to have_attributes(count: 5)
        .and eql(
          [
            [40..571, 34..442], [40..571, 460..465], [40..571, 494..499], [40..571, 658..663], [42..81, 716..755]
          ]
        )

      expect(lines[:vertical])
        .to have_attributes(count: 14)
        .and eql(
          [
            [42, 34..442], [167, 34..440], [323, 34..440], [378, 34..440], [417, 34..440],
            [472, 34..440], [513, 34..440], [568, 34..440], [44, 460..465], [44, 494..499],
            [44, 658..663], [53, 732..744], [64, 732..743], [70, 735..743]
          ]
        )
      expect(lines[:horizontal])
        .to have_attributes(count: 20)
        .and eql(
          [
            [42..571, 59], [41..570, 80], [41..570, 122], [41..570, 154], [41..570, 186],
            [42..571, 217], [41..570, 237], [41..570, 269], [41..570, 380], [42..571, 411],
            [41..569, 439], [40..571, 463], [40..571, 497], [40..571, 661], [44..56, 720],
            [63..76, 720], [51..66, 731], [63..69, 737], [71..78, 745], [46..67, 748]
          ]
        )
    end
  end
end
