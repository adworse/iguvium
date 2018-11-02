# frozen_string_literal: true

require 'convolver-light'
require 'csv'
require 'fileutils'
require 'matrix'
require 'oily_png'
require 'pdf-reader'

require_relative 'iguvium/labeler'
require_relative 'iguvium/cv'
require_relative 'iguvium/document'
require_relative 'iguvium/page'
require_relative 'iguvium/table'
require_relative 'iguvium/version'

module Iguvium
  def self.new(file)
    Document.new file
  end
end


# TODO
#
# 2) Определить структуру классов и пространство имен.
#     Есть большой соблазн влезть в общее с PDF::Reader пространство первого уровня. Типа PDF::Extractor::Document, PDF::Extractor::Page, PDF::Extractor::Table, PDF::Extractor::CV, PDF::Extractor::Labeller. Не знаю, хорошая ли это идея!
#
# 3) Он неприятно медленный. У меня есть несколько идей, как его ускорить в несколько раз, но это может причудливо поломать разное, так что:
# - тесты, хнык.
#
# 3.1) Еще нужно добавить несколько опций — в частности, опцию «распознавать с картинками или только с линиями»
#
# 4) после тестов можно паковать в гем. Тут меня интересует еще как правильно писать автодокументацию в комментариях, которая парсится в такое: https://www.rubydoc.info/gems/convolver-light/0.3.1/Convolver
#
# 5) Это будет версия, допустим, 0.8.
#
# 6) 0.9 — версия, которая умеет таблицы с торчащей гребенкой, типа
# __|____|_______|_____|
# __|____|_______|_____|
# __|____|_______|_____|
#
#     7) 1.0 — умеет то же + таблицы с merged cells.