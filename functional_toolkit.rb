# Ruby Functional Toolkit. Unsensible hacks to make the language ridiculous.

# Attach a lambda to an object as a method.
class Object

  class FunctionPrototype < Struct.new(:klass, :method_name)

    def call(instance, *args)
      raise ArgumentError unless instance.is_a? klass
      instance.send method_name, *args
    end

    def set(function)
      raise ArgumentError unless function.respond_to? :call
      klass.send :define_method, method_name, &function
    end

  end

  def prototype(name)
    FunctionPrototype.new(self, name)
  end

end

# Duck-punch Proc to auto-curry when too few arguments are supplied
class Proc
  alias_method :__noncurry_call__, :call
  private :__noncurry_call__

  def call(*args)
    begin
      __noncurry_call__(*args)
    rescue ArgumentError
      curry.(*args)
    end
  end

end

# Duck-punch Enumerable to not complain when partially mapping via .to_proc shortcut
module Enumerable
  alias_method :__noncurry_map__, :map
  private :__noncurry_map__

  def map(&proc)
    __noncurry_map__(&proc.curry)
  end

end
