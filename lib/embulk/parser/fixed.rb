module Embulk
  module Parser

    class Fixed < ParserPlugin
      Plugin.register_parser("fixed", self)

      def self.transaction(config, &control)
        decoder_task = config.load_config(Java::LineDecoder::DecoderTask)

        # configuration code:
        task = {
          "decoder" => DataSource.from_java(decoder_task.dump),
          "schema" => config.param("columns", :array, default: []),
          "strip_whitespace" => config.param("strip_whitespace", :bool, default: true)
        }

        columns = []
        task["schema"].each do |column|
          name = column["name"]
          type = column["type"].to_sym
          columns << Column.new(nil, name, type)
        end

        yield(task, columns)
      end

      def init
        @decoder = task.param("decoder", :hash).load_task(Java::LineDecoder::DecoderTask)
        @schema = @task["schema"]
        @strip_whitespace = task["strip_whitespace"]
      end


      def run(file_input)
        decoder = Java::LineDecoder.new(file_input.to_java, @decoder)
        while decoder.nextFile
          while line = decoder.poll
            process_line(line)
          end
        end

        page_builder.finish
      end

      private

      def process_line(line)
        values = @schema.map do |column|
          range = Range.new(*column["pos"].split("..").map(&:to_i)) if column["pos"]
          val = line.slice(range)
          val.strip if @strip_whitespace
        end
        page_builder.add(values)
      end

    end
  end
end
