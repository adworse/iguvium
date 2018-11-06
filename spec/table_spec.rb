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
      expect(table.to_csv(newlines: true)).to eql(
        "String Won,Applicant,Application ID,Winning Price,Date of Auction\nHOTELS,Booking.com B.V.,1-1016-75482,\"$2,200,000\",18-Nov-2015\n"
      )
    }
  end

  context 'ip' do
    let(:path) { 'spec/files/ip.pdf' }
    let(:page_index) { 1 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a(newlines: false)).to eql(
        [
          ['19', 'Наименование территориального органа Пенсионного фонда', 'Управление Пенсионного фонда РФ в Нижегородском районе г.Нижнего Новгорода'],
          ['20', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '417527500408352 13.06.2017'],
          ['Свед', 'ения о видах экономической деятельности видов экономической (ОКВЭД ОК 029-2014', 'по Общероссийскому классификатору деятельности КДЕС. Ред. 2)'],
          ['', 'Сведения об основном ви', 'де деятельности'],
          ['21', 'Код и наименование вида деятельности', '47.91.2 Торговля розничная, осуществляемая непосредственно при помощи информационно- коммуникационной сети Интернет'],
          ['22', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', 'Сведения о дополнительных', 'видах деятельности'], ['', '1', ''], ['23', 'Код и наименование вида деятельности', '47.91.1 Торговля розничная по почте'],
          ['24', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '2', ''], ['25', 'Код и наименование вида деятельности', '47.91.4 Торговля розничная, осуществляемая непосредственно при помощи телевидения, радио, телефона'],
          ['26', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '3', ''],
          ['27', 'Код и наименование вида деятельности', '53.20.3 Деятельность курьерская'],
          ['28', 'ГРН и дата внесения в ЕГРИП записи, содержащей указанные сведения', '317527500067213 02.06.2017'],
          ['', '4', ''], ['29', 'Код и наименование вида деятельности', '59.20 Деятельность в области звукозаписи и издания музыкальных произведений'],
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
      expect(table.to_csv(newlines: true)).to eql(
        "19,\"Наименование территориального органа\nПенсионного фонда\",\"Управление Пенсионного фонда РФ в\nНижегородском районе г.Нижнего\nНовгорода\"\n20,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"417527500408352\n13.06.2017\"\nСвед,\"ения о видах экономической деятельности\nвидов экономической\n(ОКВЭД ОК 029-2014\",\"по Общероссийскому классификатору\nдеятельности\nКДЕС. Ред. 2)\"\n\"\",Сведения об основном ви,де деятельности\n21,Код и наименование вида деятельности,\"47.91.2 Торговля розничная,\nосуществляемая непосредственно при\nпомощи информационно-\nкоммуникационной сети Интернет\"\n22,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",Сведения о дополнительных,видах деятельности\n\"\",1,\"\"\n23,Код и наименование вида деятельности,47.91.1 Торговля розничная по почте\n24,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",2,\"\"\n25,Код и наименование вида деятельности,\"47.91.4 Торговля розничная,\nосуществляемая непосредственно при\nпомощи телевидения, радио, телефона\"\n26,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",3,\"\"\n27,Код и наименование вида деятельности,53.20.3 Деятельность курьерская\n28,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",4,\"\"\n29,Код и наименование вида деятельности,\"59.20 Деятельность в области звукозаписи\nи издания музыкальных произведений\"\n30,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",5,\"\"\n31,Код и наименование вида деятельности,\"62.09 Деятельность, связанная с\nиспользованием вычислительной техники и\nинформационных технологий, прочая\"\n32,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",6,\"\"\n33,Код и наименование вида деятельности,\"63.11.1 Деятельность по созданию и\nиспользованию баз данных и\nинформационных ресурсов\"\n34,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",7,\"\"\n35,Код и наименование вида деятельности,63.12 Деятельность web-порталов\n36,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n"
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
          ['Схемы', '', '№ в', 'опро', 'сов', '', '▯', '▯ 1', '▯ 2', '▯ 3'],
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
      expect(table.to_csv(newlines: true)).to eql(
        "Схемы,\"\",№ в,опро,сов,\"\",▯,\"▯\n1\",\"▯\n2\",\"▯\n3\"\n1.Эмоциональная депривированность,1,19,37,55,73,\"\",\"\",\"\",\"\"\n2.Покинутость / Нестабильность,2,20,38,56,74,\"\",\"\",\"\",\"\"\n\"3.Недоверие / Ожидание жестокого\nобращения\",3,21,39,57,75,\"\",\"\",\"\",\"\"\n4.Социальная отчужденность,4,22,40,58,76,\"\",\"\",\"\",\"\"\n5.Дефективность / Стыдливость,5,23,41,59,77,\"\",\"\",\"\",\"\"\n6.Неуспешность,6,24,42,60,78,\"\",\"\",\"\",\"\"\n7.Зависимость / Беспомощность,7,25,43,61,79,\"\",\"\",\"\",\"\"\n8.Уязвимость ,8,26,44,62,80,\"\",\"\",\"\",\"\"\n\"9.Запутанность / Неразвитая \nидентичность\",9,27,45,63,81,\"\",\"\",\"\",\"\"\n10.Покорность,10,28,46,64,82,\"\",\"\",\"\",\"\"\n11.Самопожертвование,11,29,47,65,83,\"\",\"\",\"\",\"\"\n12.Подавленность эмоций,12,30,48,66,84,\"\",\"\",\"\",\"\"\n\"13.\nЖёсткие Стандарты / Придирчивость\",13,31,49,67,85,\"\",\"\",\"\",\"\"\n\"14.Привилегированность / \nГрандиозность\",14,32,50,68,86,\"\",\"\",\"\",\"\"\n15.Недостаточность самоконтроля,15,33,51,69,87,\"\",\"\",\"\",\"\"\n16. Поиск одобрения,16,34,52,70,88,\"\",\"\",\"\",\"\"\n17. Негативизм / Пессимизм,17,35,53,71,89,\"\",\"\",\"\",\"\"\n18. Пунитивность,18,36,54,72,90,\"\",\"\",\"\",\"\"\n"
      )
    }
  end

  context 'david' do
    let(:path) { 'spec/files/david.pdf' }
    let(:page_index) { 6 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a(newlines: true)).to eql(
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
      expect(table.to_csv).to eql(
        "1. ,2. Doing/Not ,3. Hidden Competing ,4. Big Assumption(s) \nCommitment (Improvement Goal) ,Doing (Instead of #1) ,Commitmen t ,\"\"\n\"I am committed to getting better at and being relaxed, being truly in the moment, present, listening more completely. \",\"I get distracted and start noticing what is going on around me, or thinking about what is next on my agenda, or thinking about where I’d rather be. I listen to portions of what someone is saying and then anticipate how they’ll finish. I might respond in a way that doesn’t accurately address what was asked. \",\"Worries: that I will feel anxiety, that others will get the wrong impression of me -­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐ I am also committed… To not letting people see what I don’t want them to see. To not having my social and professional interactions be not on my terms. To not feeling out of control. To not having things go some way I don’t want them to. \",\"I assume… I must focus all energy on tracking the things I’m saying in the conversation so that I don’t forget the thing I want to say next… Others are constantly evaluating me, forming impressions (as I am of them…). I must manage the impression others have of me or I will feel out of control, depressed. I must feel and come across to others as successful, charming, put-­‐together, smart, and witty. I assume that silence/white space in conversations is \"\n"
      )
    }
  end

  context 'quote' do
    let(:path) { 'spec/files/quote.pdf' }
    let(:page_index) { 0 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a(newlines: true)).to eql(
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
          ['A-CYA-QAHN-LR', 'Kx Wxguab gng Kq Vprschwzfvku', '$0.00', '', '$0.00', '1.00', '$0.00']
        ]
      )
      expect(table.to_csv(newlines: true)).to eql(
        "Product Code,Product,List Price,Disc %,Sale Price,Quantity,Amount\nLKHDKJHKiuewiudk,\"lihjeoriuh ISLKJHFKLJ -\nsljhkl kljdsfkjlksl;dkj\",$65842.40,57.00,$32554.86,2.00,$84864.32\nKUJGHDKUJHKJN klhs,\"wwnfdqz bghoneee pxbehsoh\ndfsdfsdfsdfsdf sf\nLKLhiofdiolip lkjdfe\n* OLoijoidf jkjhdlkfjhldkfjh\nLdkj LIKDLKJLEJ\n* ;lkjL:DKj DDD\n* sd'pksdf;ksd[foksd[ fdP:dk\n* ;ojksdpfoiu pppdppdk\nKJjjduuudu\",$0,11.00,$0,4.00,$0\n\"PIJOPIHD-LKJS-EWUCN\n-TS\",SVJB RYJO TUZEIR ZCUBUT,\"\",11.00,\"\",1.00,\"\"\nA-XAE-KAP-V.H-GL,\"QNX I.X\"\" BXV\",\"\",66.00,\"\",2.00,\"\"\n\"F-ARH-CZLDBJ-T.N-A-Z\nD\",\"G.QTRC N.I\"\" LQH\",\"\",88.00,\"\",3.00,\"\"\nW-FVJ-ATF-A-S-DP,\"11ZbV Tvbv ZJY+ Sliwomh\nWxoookn\",\"\",32.10,\"\",1.00,\"\"\nH-VPO-HUZC-ME-MBO,\"4KD Fhdoihqtbj Jxmabb\neqluuhp rcb Clqlfph RU-5426-Y4\",\"$\n86011.83\",21.00,\"$\n3582.20\",1.00,\"$\n2028.54\"\nO-PJH-HWXU-OE,\"Ceoerpq, RFA psgzgszuxur\nhfp ZX-1850-K7; Xzved hhw\nfdlt le komlvq\",$72564.91,32.00,$3493.76,1.00,$7800.24\nA-CYA-QAHN-LR,Kx Wxguab gng Kq Vprschwzfvku,$0.00,\"\",$0.00,1.00,$0.00\n"
      )
    }
  end
end
