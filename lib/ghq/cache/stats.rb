module Ghq
  module Cache
    class Stats
      class << self
        def print_repository_usage
          root = Logger.resume
          dir  = list_with_depth(1, root).sort_by(&:count).reverse.first
          count_max = dir.count.to_s.length
          (1..3).each do |depth|
            print_usage_with_depth(depth, root, count_max)
          end
        end

        private

        def print_usage_with_depth(depth, root, count_max)
          list = list_with_depth(depth, root).sort_by(&:count).reverse
          repo_max  = `ghq list`.split("\n").map(&:length).max

          name =
            case depth
            when 1 then 'host'
            when 2 then 'user'
            when 3 then 'repository'
            end

          puts "[#{name}]" + ('-' * (count_max + repo_max + 4 - name.length))
          list.first(30).each_with_index do |dir, index|
            puts "[%2d] %-#{repo_max}s %#{count_max}d" % [index + 1, dir.path_from_root, dir.count]
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
