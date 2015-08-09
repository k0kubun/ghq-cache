require 'thor'

module Ghq
  module Cache
    class CLI < Thor
      desc 'refresh', 'Refresh ~/.ghq-cache'
      def refresh
        Builder.build
      end

      desc 'log PATH', 'Log your repository access'
      def log(path)
        Logger.log(path)
      end
    end
  end
end
