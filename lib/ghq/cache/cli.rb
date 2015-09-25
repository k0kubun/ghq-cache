require 'thor'
require 'fileutils'

module Ghq
  module Cache
    class CLI < Thor
      desc 'update', 'Update ~/.ghq-cache'
      def update
        Builder.build
      end

      desc 'log PATH', 'Log your repository access'
      def log(path)
        Logger.log(path)
        refresh
      end

      desc 'purge', 'Delete ~/.ghq-cache and ~/.ghq-cache.log'
      def purge
        FileUtils.rm_f(Logger::LOG_PATH)
        FileUtils.rm_f(Builder::CACHE_PATH)
      end

      desc 'stats', 'Show the statistics of your repository usage'
      def stats
        Stats.print_repository_usage
      end
    end
  end
end
