module Ghq
  module Cache
    class Builder
      GHQ_PATH = ENV['GHQ']

      class << self
        def build
          root = Logger.resume
        end

        private

        def ghq_list
          `#{GHQ_PATH} list`.split("\n")
        end
      end
    end
  end
end
