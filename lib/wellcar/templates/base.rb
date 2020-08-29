module Wellcar
  module Templates
    class Base
      include ERB::Util

      def initialize(file_path)
        @file_path = file_path
        @before_write = []
        @after_write = []
      end

      def write
        @before_write.each {|procedure| procedure.call }

        File.open(file_path, 'w') {|file| file.write render }

        @after_write.each {|procedure| procedure.call }
      end

      def exist?
        File.exist? file_path
      end

      def render
        ERB.new(template).result(binding)
      end

      private
      
      def file_path
        raise NotImplementedError, "You have not assigned a value to @file_path" if @file_path.nil?
        @file_path
      end

      def template
        raise NotImplementedError, "You have not set the template filename. Use with_template in your concrete implementation." if @template_filename.empty?
        
        @template ||= File.read(File.join(File.dirname(__FILE__), @template_filename))
      end

      def with_template(filename)
        @template_filename = filename
      end
      
      def with_attributes(attributes)
        attributes.each do |pair|
          name = pair.first
          value = pair.last
          self.define_singleton_method(name.to_sym) { return value }
        end
      end

      def within(path)
        @before_write << Proc.new do
          @file_path = File.join path, @file_path

          next if Dir.exist? path

          FileUtils.mkdir_p path
        end
      end

      def after_write(&block)
        @after_write << (Proc.new &block)
      end
    end
  end
end
