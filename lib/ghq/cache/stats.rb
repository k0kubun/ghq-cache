module Ghq
  module Cache
    class Stats
      class << self
        def print_repository_usage
          root = Logger.resume
          (1..3).each do |depth|
            print_usage_with_depth(depth, root)
          end
        end

        private

        def print_usage_with_depth(depth, root)
          name =
            case depth
            when 1 then 'host'
            when 2 then 'user'
            when 3 then 'repository'
            end
          puts "[#{name}]" + ('-' * (30 - name.length))
          list_with_depth(depth, root).sort_by(&:count).reverse.first(30).each do |dir|
            puts "%5d %s" % [dir.count, dir.path_from_root]
          end
          puts
        end

        def list_with_depth(depth, *dirs)
          return dirs if depth == 0
          dirs.map do |dir|
            list_with_depth(depth - 1, *dir.children) 
          end.flatten.compact
        end
      end
    end
  end
end
