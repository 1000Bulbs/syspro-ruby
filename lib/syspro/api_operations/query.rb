module Syspro
  module ApiOperations
    module Query
      module ClassMethods
        include Request

        def browse(params)
          request(:get, "/Query/Browse", params)
        end

        def fetch
        end

        def query
        end

        def find
        end

        private

        def warn_on_opts_in_params(params)
          Util::OPTS_USER_SPECIFIED.each do |opt|
            if params.key?(opt)
              $stderr.puts("WARNING: #{opt} should be in opts instead of params.")
            end
          end
        end
      end # ClassMethods

      def self.included(base)
        base.extend(ClassMethods)
      end

      protected

      def request(method, url, params = {}, opts = {})
        opts = @opts.merge(Util.normalize_opts(opts))
        Request.request(method, url, params, opts)
      end
    end
  end
end

