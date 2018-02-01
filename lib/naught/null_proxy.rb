module Naught
  class NullProxy < Naught::BasicObject
    def initialize(object, null_class = ::Naught.build)
      @object = object
      @null_class = null_class
    end

    def method_missing(method, *args, &block)
      if @object.respond_to?(method)
        return NullProxy.new(@object.public_send(method, *args, &block), @null_class)
      else
        return self
      end
    end
  end
end

def NullProxy(object, null_class = ::Naught.build)
  Naught::NullProxy.new(object, null_class)
end
