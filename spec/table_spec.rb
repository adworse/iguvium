# frozen_string_literal: true

require 'rspec'

RSpec.describe Iguvium::Table do
  subject(:table) { Iguvium.read(path)[page_index].extract_tables![table_index] }

  context 'auction' do
    let(:path) { 'spec/files/auction.pdf' }
    let(:page_index) { 0 }
    let(:table_index) { 1 }

    it {
      expect(table.to_a(newlines: true)).to eql(
        [
          ['String Won', 'Applicant', 'Application ID', 'Winning Price', 'Date of Auction'],
          ['HOTELS', 'Booking.com B.V.', '1-1016-75482', '$2,200,000', '18-Nov-2015']
        ]
      )
    }
  end

  context 'ip' do
    let(:path) { 'spec/files/ip.pdf' }
    let(:page_index) { 1 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a).to eql(
        [
          ['19', 'Наименование территориального органа Пенсионного фонда', 'Управление Пенсионного фонда РФ в Нижегородском районе г.Нижнего Новгорода'],
          ['20', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '417527500408352 13.06.2017'],
          ['Сведения о видах экономической деятельности по Общероссийскому классификатору', 'видов экономической деятельности (ОКВЭД ОК 029-2014 КДЕС. Ред. 2)', ''],
          ['', 'Сведения об основном виде деятельности', ''],
          ['21', 'Код и наименование вида деятельности', '47.91.2 Торговля розничная, осуществляемая непосредственно при помощи информационно- коммуникационной сети Интернет'],
          ['22', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', 'Сведения о дополнительных видах деятельности', ''],
          ['', '1', ''], ['23', 'Код и наименование вида деятельности', '47.91.1 Торговля розничная по почте'],
          ['24', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '2', ''],
          ['25', 'Код и наименование вида деятельности', '47.91.4 Торговля розничная, осуществляемая непосредственно при помощи телевидения, радио, телефона'],
          ['26', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '3', ''], ['27', 'Код и наименование вида деятельности', '53.20.3 Деятельность курьерская'],
          ['28', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '4', ''],
          ['29', 'Код и наименование вида деятельности', '59.20 Деятельность в области звукозаписи и издания музыкальных произведений'],
          ['30', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '5', ''],
          ['31', 'Код и наименование вида деятельности', '62.09 Деятельность, связанная с использованием вычислительной техники и информационных технологий, прочая'],
          ['32', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '6', ''],
          ['33', 'Код и наименование вида деятельности', '63.11.1 Деятельность по созданию и использованию баз данных и информационных ресурсов'],
          ['34', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '7', ''],
          ['35', 'Код и наименование вида деятельности', '63.12 Деятельность web-порталов'],
          ['36', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017']
        ]
      )
    }
  end

  context 'desadaptation' do
    let(:path) { 'spec/files/desadaptation.pdf' }
    let(:page_index) { 1 }
    let(:table_index) { 1 }

    it {
      expect(table.to_a).to eql(
        [
          ['Схемы', '', '№ вопросов', '', '', '', '▯', '▯ 1', '▯ 2', '▯ 3'],
          ['1.Эмоциональная депривированность', '1', '19', '37', '55', '73', '', '', '', ''],
          ['2.Покинутость / Нестабильность', '2', '20', '38', '56', '74', '', '', '', ''],
          ['3.Недоверие / Ожидание жестокого обращения', '3', '21', '39', '57', '75', '', '', '', ''],
          ['4.Социальная отчужденность', '4', '22', '40', '58', '76', '', '', '', ''],
          ['5.Дефективность / Стыдливость', '5', '23', '41', '59', '77', '', '', '', ''],
          ['6.Неуспешность', '6', '24', '42', '60', '78', '', '', '', ''],
          ['7.Зависимость / Беспомощность', '7', '25', '43', '61', '79', '', '', '', ''],
          ['8.Уязвимость ', '8', '26', '44', '62', '80', '', '', '', ''],
          ['9.Запутанность / Неразвитая идентичность', '9', '27', '45', '63', '81', '', '', '', ''],
          ['10.Покорность', '10', '28', '46', '64', '82', '', '', '', ''],
          ['11.Самопожертвование', '11', '29', '47', '65', '83', '', '', '', ''],
          ['12.Подавленность эмоций', '12', '30', '48', '66', '84', '', '', '', ''],
          ['13. Жёсткие Стандарты / Придирчивость', '13', '31', '49', '67', '85', '', '', '', ''],
          ['14.Привилегированность / Грандиозность', '14', '32', '50', '68', '86', '', '', '', ''],
          ['15.Недостаточность самоконтроля', '15', '33', '51', '69', '87', '', '', '', ''],
          ['16. Поиск одобрения', '16', '34', '52', '70', '88', '', '', '', ''],
          ['17. Негативизм / Пессимизм', '17', '35', '53', '71', '89', '', '', '', ''],
          ['18. Пунитивность', '18', '36', '54', '72', '90', '', '', '', '']
        ]
      )
    }
  end

  context 'david' do
    let(:path) { 'spec/files/david.pdf' }
    let(:page_index) { 6 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a(newlines: true, phrases: false)).to eql(
        [
          ['1. ', '2. Doing/Not ', '3. Hidden Competing ', '4. Big Assumption(s) '],
          ["Commitment \n(Improvement \nGoal)\n ", "Doing \n(Instead of #1)\n ", "Commitmen\nt\n ", ''],
          [
            "I am \ncommitted to \ngetting better \nat and being \nrelaxed, being \ntruly in the \nmoment, \npresent, \nlistening more \ncompletely. ",
            "I get distracted \nand start noticing \nwhat is going on \naround me, or \nthinking about \nwhat is next on \nmy agenda, or \nthinking about \nwhere I’d rather \nbe. \n \nI listen to \nportions of what \nsomeone is \nsaying and then \nanticipate how \nthey’ll finish. \n \nI might respond \nin a way that \ndoesn’t \naccurately \naddress what \nwas asked. \n ",
            "Worries: that I will \nfeel anxiety, that others \nwill get the wrong \nimpression of me \n \n -­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐ \n \nI am also committed… \n \nTo not letting people \nsee what I don’t want \nthem to see. \n \nTo not having my social \nand professional \ninteractions be not on \nmy terms. \n \nTo not feeling out of \ncontrol. \n \nTo not having things go \nsome way I don’t want \nthem to. \n ",
            "I assume… \n \nI must focus all energy on \ntracking the things I’m \nsaying in the conversation \nso that I don’t forget the \nthing I want to say next… \n \nOthers are constantly \nevaluating me, forming \nimpressions (as I am of \nthem…). \n \nI must manage the \nimpression others have of \nme or I will feel out of \ncontrol, depressed. \n \nI must feel and come across \nto others as successful, \ncharming, put-­‐together, \nsmart, and witty. \n \nI assume that silence/white \nspace in conversations is "
          ]
        ]
      )
    }
  end

  context 'quote' do
    let(:path) { 'spec/files/quote.pdf' }
    let(:page_index) { 0 }
    let(:table_index) { 0 }

    it {
      expect(table.heal.to_a(newlines: true, phrases: false)).to eql(
        [
          ['Product Code', 'Product', 'List Price', 'Disc %', 'Sale Price', 'Quantity', 'Amount'],
          ['LKHDKJHKiuewiudk', "lihjeoriuh ISLKJHFKLJ -\nsljhkl kljdsfkjlksl;dkj", '$65842.40', '57.00', '$32554.86', '2.00', '$84864.32'],
          [
            'KUJGHDKUJHKJN klhs',
            "wwnfdqz bghoneee pxbehsoh\ndfsdfsdfsdfsdf sf\nLKLhiofdiolip lkjdfe\n* OLoijoidf jkjhdlkfjhldkfjh\nLdkj LIKDLKJLEJ\n* ;lkjL:DKj DDD\n* sd'pksdf;ksd[foksd[ fdP:dk\n* ;ojksdpfoiu pppdppdk\nKJjjduuudu",
            '$0', '11.00', '$0', '4.00', '$0'
          ],
          ["PIJOPIHD-LKJS-EWUCN\n-TS", 'SVJB RYJO TUZEIR ZCUBUT', '', '11.00', '', '1.00', ''],
          ['A-XAE-KAP-V.H-GL', 'QNX I.X" BXV', '', '66.00', '', '2.00', ''],
          ["F-ARH-CZLDBJ-T.N-A-Z\nD", 'G.QTRC N.I" LQH', '', '88.00', '', '3.00', ''],
          ['W-FVJ-ATF-A-S-DP', "11ZbV Tvbv ZJY+ Sliwomh\nWxoookn", '', '32.10', '', '1.00', ''],
          ['H-VPO-HUZC-ME-MBO', "4KD Fhdoihqtbj Jxmabb\neqluuhp rcb Clqlfph RU-5426-Y4", "$\n86011.83", '21.00', "$\n3582.20", '1.00', "$\n2028.54"],
          ['O-PJH-HWXU-OE', "Ceoerpq, RFA psgzgszuxur\nhfp ZX-1850-K7; Xzved hhw\nfdlt le komlvq", '$72564.91', '32.00', '$3493.76', '1.00', '$7800.24'],
          ['A-CYA-QAHN-LR', 'Kx Wxguab gng Kq Vprschwzfvku', '$0.00', '', '$0.00', '1.00', '$0.00'],
          ['N-ISU-MTNUTE-L.J-T-H', 'Dhwzt, ZUE, TEXI, 2547RB', '', '', '', '', '']
        ]
      )
    }
  end

  context 'quote' do
    let(:path) { 'spec/files/foo.pdf' }
    let(:page_index) { 0 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a(phrases: true)).to eql(
        [
          ['', '', '', '', 'Percent Fuel Savings', '', ''],
          ['Cycle Name', 'KI (1/km)', 'Distance (mi)', 'Improved Speed', 'Decreased Accel', 'Eliminate Stops', 'Decreased Idle'],
          %w[2012_2 3.30 1.3 5.9% 9.5% 29.2% 17.4%],
          %w[2145_1 0.68 11.2 2.4% 0.1% 9.5% 2.7%],
          %w[4234_1 0.59 58.7 8.5% 1.3% 8.5% 3.3%],
          %w[2032_2 0.17 57.8 21.7% 0.3% 2.7% 1.2%],
          %w[4171_1 0.07 173.9 58.1% 1.6% 2.1% 0.5%]
        ]
      )
    }
  end
end
