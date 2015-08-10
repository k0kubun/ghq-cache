module Ghq
  module Cache
    class Builder
      CACHE_PATH = File.expand_path('~/.ghq-cache')
      GHQ_PATH   = ENV['GHQ'] || '/usr/local/bin/ghq'

      class << self
        def build
          root = Logger.resume
          obsolete_paths.each do |path|
            root.remove_path(path)
          end
          ghq_list.each do |path|
            root.register_path(File.join(root.name, path))
          end

          dirs = flatten(root).sort_by do |dir|
            sort_key(dir)
          end.reverse
          cache = dirs.map(&:full_path).join("\n").concat("\n")
          File.write(CACHE_PATH, cache)
        end

        private

        def flatten(*dirs)
          dirs.map do |dir|
            next dir if dir.children.empty?
            flatten(*dir.children)
          end.flatten
        end

        def sort_key(dir)
          return [dir.count] unless dir.parent
          [dir.count, *sort_key(dir.parent)]
        end

        def obsolete_paths
          cached_paths =
            if File.exist?(CACHE_PATH)
              File.read(CACHE_PATH).split("\n")
            else
              []
            end
          cached_paths - ghq_list
        end

        def ghq_list
          `#{GHQ_PATH} list`.split("\n")
        end
      end
    end
  end
end
