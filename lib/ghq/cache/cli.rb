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
        refresh
      end

      desc 'purge', 'Delete ~/.ghq-cache and ~/.ghq-cache.log'
      def purge
        File.rm_f(Logger::LOG_PATH)
        File.rm_f(Builder::CACHE_PATH)
      end
    end
  end
end
