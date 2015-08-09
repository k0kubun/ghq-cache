require 'yaml'

module Ghq
  module Cache
    class Logger
      LOG_PATH = File.expand_path('~/.ghq-cahe.log')

      class << self
        def log(path)
          initialize_log! unless initialized?

          root = resume
          root.count_path(path)
          save_log(root)
        end

        def resume
          initialize_log! unless initialized?

          yaml = File.read(LOG_PATH)
          YAML.load(yaml)
        end

        private

        def initialize_log!
          root = Directory.new(ghq_root)
          save_log(root)
        end

        def initialized?
          File.exist?(LOG_PATH)
        end

        def save_log(object)
          File.write(LOG_PATH, object.to_yaml)
        end

        def ghq_root
          File.join(ENV['GOPATH'], 'src')
        end
      end
    end
  end
end
