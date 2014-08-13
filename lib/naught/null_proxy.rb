module Naught
  class NullProxy < Naught::BasicObject
    def initialize(object, null_class = ::Naught.build)
      @object = object
      @null_class = null_class
    end

    def __object__
      return @null_class.new if @object.nil?
      @object
    end

    def method_missing(method, *args, &block)
      return self if @object.nil?
      NullProxy.new(@object.public_send(method, *args, &block), @null_class)
    end

    def respond_to?(method, include_private = false)
      return true if method.to_sym == :__object__
      @object.respond_to?(method, include_private)
    end
  end
end

def NullProxy(object, null_class = ::Naught.build)
  Naught::NullProxy.new(object, null_class)
end
