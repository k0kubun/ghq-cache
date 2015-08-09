module Ghq
  module Cache
    class Directory < Struct.new(:name, :count, :children)
      def initialize(*)
        super
        self.count ||= 0
        self.children ||= []
      end

      def count_path(path)
        raise "Path didn't matched to Directory" unless path =~ /^#{name}/
        self.count += 1

        relative_path = path.gsub(%r[^#{name}/?], '')
        return if relative_path.empty?

        child = create_or_find(relative_path.split('/').first)
        child.count_path(relative_path)
      end

      private

      def create_or_find(child_name)
        child = self.children.find do |directory|
          directory.name == child_name
        end
        return child if child

        child = Directory.new(child_name)
        self.children << child
        child
      end
    end
  end
end
