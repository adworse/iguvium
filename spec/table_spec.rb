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

  context 'ip' do
    let(:path) { 'spec/files/ip.pdf' }
    let(:page_index) { 1 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a).to eql(
        [
          ['19', "Наименование территориального органа\nПенсионного фонда", "Управление Пенсионного фонда РФ в\nНижегородском районе г.Нижнего\nНовгорода"],
          ['20', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "417527500408352\n13.06.2017"],
          ['Свед', "ения о видах экономической деятельности\nвидов экономической\n(ОКВЭД ОК 029-2014", "по Общероссийскому классификатору\nдеятельности\nКДЕС. Ред. 2)"],
          ['', 'Сведения об основном ви', 'де деятельности'],
          ['21', 'Код и наименование вида деятельности', "47.91.2 Торговля розничная,\nосуществляемая непосредственно при\nпомощи информационно-\nкоммуникационной сети Интернет"],
          ['22', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', 'Сведения о дополнительных', 'видах деятельности'], ['', '1', ''], ['23', 'Код и наименование вида деятельности', '47.91.1 Торговля розничная по почте'],
          ['24', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '2', ''], ['25', 'Код и наименование вида деятельности', "47.91.4 Торговля розничная,\nосуществляемая непосредственно при\nпомощи телевидения, радио, телефона"],
          ['26', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '3', ''],
          ['27', 'Код и наименование вида деятельности', '53.20.3 Деятельность курьерская'],
          ['28', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '4', ''], ['29', 'Код и наименование вида деятельности', "59.20 Деятельность в области звукозаписи\nи издания музыкальных произведений"],
          ['30', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '5', ''],
          ['31', 'Код и наименование вида деятельности', "62.09 Деятельность, связанная с\nиспользованием вычислительной техники и\nинформационных технологий, прочая"],
          ['32', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '6', ''],
          ['33', 'Код и наименование вида деятельности', "63.11.1 Деятельность по созданию и\nиспользованию баз данных и\nинформационных ресурсов"],
          ['34', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"],
          ['', '7', ''],
          ['35', 'Код и наименование вида деятельности', '63.12 Деятельность web-порталов'],
          ['36', "ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения", "317527500067213\n02.06.2017"]
        ]
      )
      expect(table.to_csv).to eql(
        "19,\"Наименование территориального органа\nПенсионного фонда\",\"Управление Пенсионного фонда РФ в\nНижегородском районе г.Нижнего\nНовгорода\"\n20,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"417527500408352\n13.06.2017\"\nСвед,\"ения о видах экономической деятельности\nвидов экономической\n(ОКВЭД ОК 029-2014\",\"по Общероссийскому классификатору\nдеятельности\nКДЕС. Ред. 2)\"\n\"\",Сведения об основном ви,де деятельности\n21,Код и наименование вида деятельности,\"47.91.2 Торговля розничная,\nосуществляемая непосредственно при\nпомощи информационно-\nкоммуникационной сети Интернет\"\n22,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",Сведения о дополнительных,видах деятельности\n\"\",1,\"\"\n23,Код и наименование вида деятельности,47.91.1 Торговля розничная по почте\n24,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",2,\"\"\n25,Код и наименование вида деятельности,\"47.91.4 Торговля розничная,\nосуществляемая непосредственно при\nпомощи телевидения, радио, телефона\"\n26,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",3,\"\"\n27,Код и наименование вида деятельности,53.20.3 Деятельность курьерская\n28,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",4,\"\"\n29,Код и наименование вида деятельности,\"59.20 Деятельность в области звукозаписи\nи издания музыкальных произведений\"\n30,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",5,\"\"\n31,Код и наименование вида деятельности,\"62.09 Деятельность, связанная с\nиспользованием вычислительной техники и\nинформационных технологий, прочая\"\n32,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",6,\"\"\n33,Код и наименование вида деятельности,\"63.11.1 Деятельность по созданию и\nиспользованию баз данных и\nинформационных ресурсов\"\n34,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n\"\",7,\"\"\n35,Код и наименование вида деятельности,63.12 Деятельность web-порталов\n36,\"ГРН и дата внесения в ЕГРИП записи,\nсодержащей указанные сведения\",\"317527500067213\n02.06.2017\"\n"
      )
    }
  end

  context 'report' do
    let(:path) { 'spec/files/desadaptation.pdf' }
    let(:page_index) { 1 }
    let(:table_index) { 1 }

    it {
      expect(table.to_a).to eql(
        [
          ['Схемы', '', '№  в', 'опро', 'сов', '', '▯', "▯\n1", "▯\n2", "▯\n3"],
          ['1.Эмоциональная  депривированность', '1', '19', '37', '55', '73', '', '', '', ''],
          ['2.Покинутость  /  Нестабильность', '2', '20', '38', '56', '74', '', '', '', ''],
          ["3.Недоверие  /  Ожидание  жестокого\nобращения", '3', '21', '39', '57', '75', '', '', '', ''],
          ['4.Социальная  отчужденность', '4', '22', '40', '58', '76', '', '', '', ''],
          ['5.Дефективность  /  Стыдливость', '5', '23', '41', '59', '77', '', '', '', ''],
          ['6.Неуспешность', '6', '24', '42', '60', '78', '', '', '', ''],
          ['7.Зависимость  /  Беспомощность', '7', '25', '43', '61', '79', '', '', '', ''],
          ['8.Уязвимость    ', '8', '26', '44', '62', '80', '', '', '', ''],
          ["9.Запутанность  /  Неразвитая  \nидентичность", '9', '27', '45', '63', '81', '', '', '', ''],
          ['10.Покорность', '10', '28', '46', '64', '82', '', '', '', ''],
          ['11.Самопожертвование', '11', '29', '47', '65', '83', '', '', '', ''],
          ['12.Подавленность  эмоций', '12', '30', '48', '66', '84', '', '', '', ''],
          ["13.\nЖёсткие  Стандарты  /  Придирчивость", '13', '31', '49', '67', '85', '', '', '', ''],
          ["14.Привилегированность  /  \nГрандиозность", '14', '32', '50', '68', '86', '', '', '', ''],
          ['15.Недостаточность  самоконтроля', '15', '33', '51', '69', '87', '', '', '', ''],
          ['16.  Поиск  одобрения', '16', '34', '52', '70', '88', '', '', '', ''],
          ['17.  Негативизм  /  Пессимизм', '17', '35', '53', '71', '89', '', '', '', ''],
          ['18.  Пунитивность', '18', '36', '54', '72', '90', '', '', '', '']
        ]
      )
      expect(table.to_csv).to eql(
        "Схемы,\"\",№  в,опро,сов,\"\",▯,\"▯\n1\",\"▯\n2\",\"▯\n3\"\n1.Эмоциональная  депривированность,1,19,37,55,73,\"\",\"\",\"\",\"\"\n2.Покинутость  /  Нестабильность,2,20,38,56,74,\"\",\"\",\"\",\"\"\n\"3.Недоверие  /  Ожидание  жестокого\nобращения\",3,21,39,57,75,\"\",\"\",\"\",\"\"\n4.Социальная  отчужденность,4,22,40,58,76,\"\",\"\",\"\",\"\"\n5.Дефективность  /  Стыдливость,5,23,41,59,77,\"\",\"\",\"\",\"\"\n6.Неуспешность,6,24,42,60,78,\"\",\"\",\"\",\"\"\n7.Зависимость  /  Беспомощность,7,25,43,61,79,\"\",\"\",\"\",\"\"\n8.Уязвимость    ,8,26,44,62,80,\"\",\"\",\"\",\"\"\n\"9.Запутанность  /  Неразвитая  \nидентичность\",9,27,45,63,81,\"\",\"\",\"\",\"\"\n10.Покорность,10,28,46,64,82,\"\",\"\",\"\",\"\"\n11.Самопожертвование,11,29,47,65,83,\"\",\"\",\"\",\"\"\n12.Подавленность  эмоций,12,30,48,66,84,\"\",\"\",\"\",\"\"\n\"13.\nЖёсткие  Стандарты  /  Придирчивость\",13,31,49,67,85,\"\",\"\",\"\",\"\"\n\"14.Привилегированность  /  \nГрандиозность\",14,32,50,68,86,\"\",\"\",\"\",\"\"\n15.Недостаточность  самоконтроля,15,33,51,69,87,\"\",\"\",\"\",\"\"\n16.  Поиск  одобрения,16,34,52,70,88,\"\",\"\",\"\",\"\"\n17.  Негативизм  /  Пессимизм,17,35,53,71,89,\"\",\"\",\"\",\"\"\n18.  Пунитивность,18,36,54,72,90,\"\",\"\",\"\",\"\"\n"
      )
    }
  end

  context 'david' do
    let(:path) { 'spec/files/david.pdf' }
    let(:page_index) { 6 }
    let(:table_index) { 0 }

    it {
      expect(table.to_a).to eql(
        [
          ["1.\t\r  \nCommitment\t\r  ", "2.\t\r  Doing/Not\t\r  \nDoing\t\r  ", "3.\t\r  Hidden\t\r  Competing\t\r  ", "4.\t\r  Big\t\r  Assumption(s)\t\r  "],
          ["(Improvement\t\r  \nGoal)\n\t\r  ", "(Instead\t\r  of\t\r  #1)\n\t\r  ", "Commitmen\nt\n\t\r  ", ''],
          [
            "I\t\r  am\t\r  \ncommitted\t\r  to\t\r  \ngetting\t\r  better\t\r  \nat\t\r  and\t\r  being\t\r  \nrelaxed,\t\r  being\t\r  \ntruly\t\r  in\t\r  the\t\r  \nmoment,\t\r  \npresent,\t\r  \nlistening\t\r  more\t\r  \ncompletely.\t\r  \t\r  ",
            "I\t\r  get\t\r  distracted\t\r  \nand\t\r  start\t\r  noticing\t\r  \nwhat\t\r  is\t\r  going\t\r  on\t\r  \naround\t\r  me,\t\r  or\t\r  \nthinking\t\r  about\t\r  \nwhat\t\r  is\t\r  next\t\r  on\t\r  \nmy\t\r  agenda,\t\r  or\t\r  \nthinking\t\r  about\t\r  \nwhere\t\r  I’d\t\r  rather\t\r  \nbe.\t\r  \n\t\r  \nI\t\r  listen\t\r  to\t\r  \nportions\t\r  of\t\r  what\t\r  \nsomeone\t\r  is\t\r  \nsaying\t\r  and\t\r  then\t\r  \nanticipate\t\r  how\t\r  \nthey’ll\t\r  finish.\t\r  \n\t\r  \nI\t\r  might\t\r  respond\t\r  \nin\t\r  a\t\r  way\t\r  that\t\r  \ndoesn’t\t\r  \naccurately\t\r  \naddress\t\r  what\t\r  \nwas\t\r  asked.\t\r  \t\r  \n\t\r  ",
            "Worries:\t\r  \t\r  that\t\r  I\t\r  will\t\r  \nfeel\t\r  anxiety,\t\r  that\t\r  others\t\r  \nwill\t\r  get\t\r  the\t\r  wrong\t\r  \nimpression\t\r  of\t\r  me\t\r  \n\t\r  \n\t\r  -­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐\t\r  \n\t\r  \nI\t\r  am\t\r  also\t\r  committed…\t\r  \n\t\r  \nTo\t\r  not\t\r  letting\t\r  people\t\r  \nsee\t\r  what\t\r  I\t\r  don’t\t\r  want\t\r  \nthem\t\r  to\t\r  see.\t\r  \n\t\r  \nTo\t\r  not\t\r  having\t\r  my\t\r  social\t\r  \nand\t\r  professional\t\r  \ninteractions\t\r  be\t\r  not\t\r  on\t\r  \nmy\t\r  terms.\t\r  \n\t\r  \nTo\t\r  not\t\r  feeling\t\r  out\t\r  of\t\r  \ncontrol.\t\r  \n\t\r  \nTo\t\r  not\t\r  having\t\r  things\t\r  go\t\r  \nsome\t\r  way\t\r  I\t\r  don’t\t\r  want\t\r  \nthem\t\r  to.\t\r  \n\t\r  ",
            "I\t\r  assume…\t\r  \n\t\r  \nI\t\r  must\t\r  focus\t\r  all\t\r  energy\t\r  on\t\r  \ntracking\t\r  the\t\r  things\t\r  I’m\t\r  \nsaying\t\r  in\t\r  the\t\r  conversation\t\r  \nso\t\r  that\t\r  I\t\r  don’t\t\r  forget\t\r  the\t\r  \nthing\t\r  I\t\r  want\t\r  to\t\r  say\t\r  next…\t\r  \n\t\r  \nOthers\t\r  are\t\r  constantly\t\r  \nevaluating\t\r  me,\t\r  forming\t\r  \nimpressions\t\r  (as\t\r  I\t\r  am\t\r  of\t\r  \nthem…).\t\r  \n\t\r  \nI\t\r  must\t\r  manage\t\r  the\t\r  \nimpression\t\r  others\t\r  have\t\r  of\t\r  \nme\t\r  or\t\r  I\t\r  will\t\r  feel\t\r  out\t\r  of\t\r  \ncontrol,\t\r  depressed.\t\r  \n\t\r  \nI\t\r  must\t\r  feel\t\r  and\t\r  come\t\r  across\t\r  \nto\t\r  others\t\r  as\t\r  successful,\t\r  \ncharming,\t\r  put-­‐together,\t\r  \nsmart,\t\r  and\t\r  witty.\t\r  \n\t\r  \nI\t\r  assume\t\r  that\t\r  silence/white\t\r  \nspace\t\r  in\t\r  conversations\t\r  is\t\r  "
          ]
        ]
      )
      expect(table.to_csv).to eql(
        "\"1.\t\r  \nCommitment\t\r  \",\"2.\t\r  Doing/Not\t\r  \nDoing\t\r  \",\"3.\t\r  Hidden\t\r  Competing\t\r  \",\"4.\t\r  Big\t\r  Assumption(s)\t\r  \"\n\"(Improvement\t\r  \nGoal)\n\t\r  \",\"(Instead\t\r  of\t\r  #1)\n\t\r  \",\"Commitmen\nt\n\t\r  \",\"\"\n\"I\t\r  am\t\r  \ncommitted\t\r  to\t\r  \ngetting\t\r  better\t\r  \nat\t\r  and\t\r  being\t\r  \nrelaxed,\t\r  being\t\r  \ntruly\t\r  in\t\r  the\t\r  \nmoment,\t\r  \npresent,\t\r  \nlistening\t\r  more\t\r  \ncompletely.\t\r  \t\r  \",\"I\t\r  get\t\r  distracted\t\r  \nand\t\r  start\t\r  noticing\t\r  \nwhat\t\r  is\t\r  going\t\r  on\t\r  \naround\t\r  me,\t\r  or\t\r  \nthinking\t\r  about\t\r  \nwhat\t\r  is\t\r  next\t\r  on\t\r  \nmy\t\r  agenda,\t\r  or\t\r  \nthinking\t\r  about\t\r  \nwhere\t\r  I’d\t\r  rather\t\r  \nbe.\t\r  \n\t\r  \nI\t\r  listen\t\r  to\t\r  \nportions\t\r  of\t\r  what\t\r  \nsomeone\t\r  is\t\r  \nsaying\t\r  and\t\r  then\t\r  \nanticipate\t\r  how\t\r  \nthey’ll\t\r  finish.\t\r  \n\t\r  \nI\t\r  might\t\r  respond\t\r  \nin\t\r  a\t\r  way\t\r  that\t\r  \ndoesn’t\t\r  \naccurately\t\r  \naddress\t\r  what\t\r  \nwas\t\r  asked.\t\r  \t\r  \n\t\r  \",\"Worries:\t\r  \t\r  that\t\r  I\t\r  will\t\r  \nfeel\t\r  anxiety,\t\r  that\t\r  others\t\r  \nwill\t\r  get\t\r  the\t\r  wrong\t\r  \nimpression\t\r  of\t\r  me\t\r  \n\t\r  \n\t\r  -­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐-­‐\t\r  \n\t\r  \nI\t\r  am\t\r  also\t\r  committed…\t\r  \n\t\r  \nTo\t\r  not\t\r  letting\t\r  people\t\r  \nsee\t\r  what\t\r  I\t\r  don’t\t\r  want\t\r  \nthem\t\r  to\t\r  see.\t\r  \n\t\r  \nTo\t\r  not\t\r  having\t\r  my\t\r  social\t\r  \nand\t\r  professional\t\r  \ninteractions\t\r  be\t\r  not\t\r  on\t\r  \nmy\t\r  terms.\t\r  \n\t\r  \nTo\t\r  not\t\r  feeling\t\r  out\t\r  of\t\r  \ncontrol.\t\r  \n\t\r  \nTo\t\r  not\t\r  having\t\r  things\t\r  go\t\r  \nsome\t\r  way\t\r  I\t\r  don’t\t\r  want\t\r  \nthem\t\r  to.\t\r  \n\t\r  \",\"I\t\r  assume…\t\r  \n\t\r  \nI\t\r  must\t\r  focus\t\r  all\t\r  energy\t\r  on\t\r  \ntracking\t\r  the\t\r  things\t\r  I’m\t\r  \nsaying\t\r  in\t\r  the\t\r  conversation\t\r  \nso\t\r  that\t\r  I\t\r  don’t\t\r  forget\t\r  the\t\r  \nthing\t\r  I\t\r  want\t\r  to\t\r  say\t\r  next…\t\r  \n\t\r  \nOthers\t\r  are\t\r  constantly\t\r  \nevaluating\t\r  me,\t\r  forming\t\r  \nimpressions\t\r  (as\t\r  I\t\r  am\t\r  of\t\r  \nthem…).\t\r  \n\t\r  \nI\t\r  must\t\r  manage\t\r  the\t\r  \nimpression\t\r  others\t\r  have\t\r  of\t\r  \nme\t\r  or\t\r  I\t\r  will\t\r  feel\t\r  out\t\r  of\t\r  \ncontrol,\t\r  depressed.\t\r  \n\t\r  \nI\t\r  must\t\r  feel\t\r  and\t\r  come\t\r  across\t\r  \nto\t\r  others\t\r  as\t\r  successful,\t\r  \ncharming,\t\r  put-­‐together,\t\r  \nsmart,\t\r  and\t\r  witty.\t\r  \n\t\r  \nI\t\r  assume\t\r  that\t\r  silence/white\t\r  \nspace\t\r  in\t\r  conversations\t\r  is\t\r  \"\n"
      )
    }
  end
end
