module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path.split('/')
        @controller = controller
        @action = action
      end

      def match?(method, path)
        method == @method && compare_paths(path.split('/'))
      end

      def params(path)
        extract_params(path.split('/'))
      end

      private

      def compare_paths(request_path)
        return false unless request_path.size == @path.size

        @path.each_with_index.all? { |part, index| part.start_with?(':') || part == request_path[index] }
      end

      def extract_params(request_path)
        params = {}

        @path.each_with_index do |part, index|
          if part.start_with?(':')
            param_name = part[1..].to_sym
            params[param_name] = request_path[index]
          end
        end

        params
      end
    end
  end
end
