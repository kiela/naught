require 'forwardable'
require 'naught/null_class_builder/command'

module Naught
  class NullClassBuilder
    module Commands
      class Wrapper < Naught::NullClassBuilder::Command
        def call
          defer(:class => true) do |subject|
            subject.module_eval do
              def self.wrap(instance_to_wrap)
                self.new(instance_to_wrap)
              end
            end
          end

          defer do |subject|
            subject.module_eval do
              extend Forwardable
              def_delegators :__wrapped_instance__, :to_a, :to_c, :to_f, :to_h, :to_i, :to_r, :to_s

              attr_reader :__wrapped_instance__

              def initialize(instance_to_wrap)
                @__wrapped_instance__ = instance_to_wrap
              end

              # Make puts to work
              def to_ary
                [__wrapped_instance__]
              end
            end
          end

          defer do |subject|
            subject.module_exec do
              inspect_proc = lambda { "<null:#{__wrapped_instance__.inspect}>" }
              define_method(:inspect, &inspect_proc)
            end
          end

          defer(:prepend => true) do |subject|
            subject.module_exec do
              original_method_missing = instance_method(:method_missing)
              define_method(:method_missing) do |method_name, *args, &block|
                if @__wrapped_instance__.respond_to?(method_name)
                  instance_to_wrap = @__wrapped_instance__.public_send(method_name, *args, &block)
                  self.class.wrap(instance_to_wrap)
                else
                  original_method_missing.bind(self).call(method_name, *args, &block)
                end
              end
            end
          end
        end
      end
    end
  end
end

=begin
            binding.pry
            #subject.instance_variable_set(:@wrapped_instance, @instance_to_wrap)
            methods = (@instance_to_wrap.class.instance_methods - Object.instance_methods)
            methods.each do |method|
              subject.module_exec(@instance_to_wrap) do |wrapped_instance|
                define_method(method) do |*args, &block|
                  wrapped_instance.send(method, *args, &block)
                end
              end
            end

            binding.pry

            subject.module_eval do
              extend Forwardable
              def_delegators :wrapped_instance, :bar

              def wrapped_instance
                bidning.pry
              end
            end

            binding.pry
            puts "methods: #{methods.inspect}"

            subject.module_exec do
              methods.each do |method|
                puts "method: #{method}"
                define_method(method) do |*args, &block|
                  puts "args: #{args.inspect}"
                  puts "block: #{block.inspect}"
                end
              end
            end
          end
        end
      end
    end
  end
end
=end
