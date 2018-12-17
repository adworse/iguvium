# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::CV do
  subject(:cv) { Iguvium::CV.new(Iguvium::Image.read(path, page_index + 1, images: true, gspath: gspath)) }

  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }

    let(:gspath) do
      return 'gs' unless RbConfig::CONFIG['host_os'].match(/mswin|mingw|cygwin/)

      gspath = Dir.glob('C:/Program Files/gs/gs*/bin/gswin??c.exe').first.tr('/', '\\')
      "\"#{gspath}\""
    end

    let(:lines) { cv.recognize[:lines] }
    let(:boxes) { cv.recognize[:boxes] }

    it do
      expect(boxes)
        .to have_attributes(count: 13)
        .and eql(
          [
            [66..534, 328..425], [72..186, 436..437], [66..534, 478..534],
            [72..136, 544..545], [66..534, 580..608], [72..119, 619..620],
            [79..84, 671..679], [87..93, 672..679], [96..103, 672..679],
            [106..113, 672..679], [117..124, 672..679], [72..131, 681..684],
            [80..118, 688..719]
          ]
        )

      expect(lines[:vertical])
        .to have_attributes(count: 24)
        .and eql(
          [
            [88, 696..711], [116, 696..711], [108, 675..682], [81, 669..680], [122, 670..675],
            [74, 617..622], [160, 580..610], [347, 580..610], [66, 578..609], [253, 579..609],
            [440, 579..609], [534, 578..608], [74, 542..547], [66, 477..536], [534, 476..536],
            [222, 477..535], [378, 477..535], [74, 434..439], [66, 326..427], [160, 327..426],
            [253, 326..426], [347, 327..426], [440, 326..426], [534, 328..425]
          ]
        )
      expect(lines[:horizontal])
        .to have_attributes(count: 25)
        .and eql(
          [
            [95..108, 718], [78..86, 701], [79..86, 694], [103..108, 690], [84..133, 683],
            [70..78, 681], [79..84, 677], [107..124, 676], [70..120, 620], [64..534, 608],
            [65..534, 594], [66..532, 580], [70..138, 545], [64..536, 534], [65..535, 506],
            [65..534, 492], [64..532, 478], [70..188, 436], [64..536, 425], [65..536, 398],
            [65..536, 384], [65..536, 370], [65..536, 356], [65..535, 342], [64..533, 328]
          ]
        )
    end
  end

  context 'quote' do
    let(:path) { 'spec/files/quote.pdf' }
    let(:page_index) { 0 }
    let(:gspath) do
      return 'gs' unless RbConfig::CONFIG['host_os'].match(/mswin|mingw|cygwin/)

      gspath = Dir.glob('C:/Program Files/gs/gs*/bin/gswin??c.exe').first.tr('/', '\\')
      "\"#{gspath}\""
    end

    let(:lines) { cv.recognize[:lines] }
    let(:boxes) { cv.recognize[:boxes] }

    it do
      expect(boxes)
        .to have_attributes(count: 5)
        .and eql(
          [
            [42..569, 36..440], [42..569, 462..463], [42..569, 496..497],
            [42..569, 660..661], [44..79, 718..753]
          ]
        )

      expect(lines[:vertical])
        .to have_attributes(count: 14)
        .and eql(
          [
            [53, 732..744], [64, 732..743], [70, 735..743], [44, 658..663], [44, 494..499],
            [44, 460..465], [42, 34..442], [378, 34..441], [417, 34..441], [472, 34..441],
            [513, 34..441], [167, 34..440], [323, 34..440], [568, 34..439]
          ]
        )
      expect(lines[:horizontal])
        .to have_attributes(count: 20)
        .and eql(
          [
            [46..67, 748], [71..78, 745], [63..69, 737], [51..66, 731], [44..56, 720],
            [63..76, 720], [40..571, 661], [40..571, 497], [40..571, 463], [40..567, 439],
            [42..571, 411], [41..570, 380], [41..570, 269], [41..570, 237], [42..571, 217],
            [41..570, 186], [41..570, 154], [41..570, 122], [41..570, 80], [42..571, 59]
          ]
        )
    end
  end
end
