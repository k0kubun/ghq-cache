module Ghq
  module Cache
    class Builder
      CACHE_PATH = File.expand_path('~/.ghq-cache')
      GHQ_PATH   = ENV['GHQ'] || '/usr/local/bin/ghq'

      class << self
        def build
          root = Logger.resume
          ghq_list.each do |path|
            root.register_path(File.join(root.name, path))
          end

          cache = build_paths(root).join("\n").concat("\n")
          File.write(CACHE_PATH, cache)
        end

        private

        def ghq_list
          `#{GHQ_PATH} list`.split("\n")
        end

        def build_paths(directory)
          paths = []
          sort_children(directory.children).each do |child|
            if child.children.empty?
              paths << File.join(directory.name, child.name)
              next
            end

            build_paths(child).each do |path|
              if directory.root?
                paths << path
                next
              end
              paths << File.join(directory.name, path)
            end
          end
          paths
        end

        def sort_children(children)
          children.sort_by do |child|
            [-1 * child.count, child.name]
          end
        end
      end
    end
  end
end
