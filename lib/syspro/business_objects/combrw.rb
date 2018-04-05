require "syspro/business_objects/parsers/combrw_parser"
require "erb"

module Syspro
  module BusinessObjects
    class ComBrw < ApiResource
      include Syspro::ApiOperations::Query
      include Syspro::BusinessObjects::Parsers

      attr_accessor :browse_name, :start_condition, :return_rows, :filters,
                    :table_name, :title, :columns

      def call(user_id)
        xml_in = template.result(binding)
        params = { "UserId" => user_id, "XmlIn" => xml_in }
        resp = ComBrw.browse(params)
        parse_response(resp)
      end

      def template
        ERB.new File.read(File.expand_path("schemas/combrw.xml.erb", File.dirname(__FILE__))), nil, "%"
      end

      def parse_response(resp)
        handle_errors(resp)
        ComBrwParser.parse(resp[0].data)
      end

      def handle_errors(resp)
        body = resp[0].http_body
        if body.match(/^(ERROR)/)
          raise SysproError, body
        end
      end
    end
  end
end

