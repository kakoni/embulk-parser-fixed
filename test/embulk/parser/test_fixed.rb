require "prepare_embulk"
require "embulk/parser/fixed"
require "embulk/data_source"


module Embulk
  module Parser
    class FixedTest < Test::Unit::TestCase

      class TestProcessLine < self

        def test_foo
          mock(page_builder).add(["eka", "Toka", "Kolmas", "Neljas"])
          line = "ekaTokaKolmas Neljas"
          plugin.send(:process_line, line)
        end

        def plugin
         @plugin ||= Fixed.new(DataSource[task], schema, page_builder)
        end

        def page_builder
          @page_builder ||= Object.new
        end

        def task
          {
            "decoder" => {"Charset" => "UTF-8", "Newline" => "CRLF"},
            "schema" => columns,
            "strip_whitespace" => true,
          }
        end

        def columns
          [
            {"name" => "foo", "type" => :string, "pos" => "0..2"},
            {"name" => "bar", "type" => :string, "pos" => "3..6"},
            {"name" => "baz", "type" => :string, "pos" => "7..12"},
            {"name" => "qux", "type" => :string, "pos" => "14..19"},
          ]
        end

        def schema
          columns.map do |column|
            Column.new(nil, column["name"], column["type"].to_sym)
          end
        end

      end
    end
  end
end
