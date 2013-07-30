# Ruby Functional Toolkit. Unsensible hacks to make the language ridiculous.

class Object

  class FunctionPrototype < Struct.new(:klass, :method_name)

    def call(instance, *args)
      raise ArgumentError unless instance.is_a? klass
      instance.send method_name, *args
    end

    # Attach a lambda to an object as a method.
    def set(function)
      raise ArgumentError unless function.respond_to? :call
      klass.send :define_method, method_name, ->(*args){ function.(->{ self }.()) }
    end

  end

  # Call me maybe.
  def maybe
    Maybe.new(self)
  end


  def prototype(name)
    FunctionPrototype.new(self, name)
  end

end

# Duck-punch Proc to auto-curry when too-few arguments are supplied
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

  def map(&proc)
    __noncurry_map__(&proc.curry)
  end

  # Perform map and each using num_groups parallel threads
  NUM_GROUPS = 16
  def peach(&proc)
    parts = each_slice((self.size/Float(NUM_GROUPS)).ceil)
    parts.__noncurry_map__ { |part|
      Thread.new { part.each(&proc) }
    }.__noncurry_map__(&:join)
  end

  def pmap(greedy: false, &proc)
    if greedy
      map { |element| Thread.new { Thread.current[:out] = proc.(element) } }.map(&:join).map { |t| t[:out] }
    else
      parts = each_slice((self.size/Float(NUM_GROUPS)).ceil)
      parts.__noncurry_map__ { |part|
        Thread.new {
          Thread.current[:out] = part.__noncurry_map__(&proc)
        }
      }.__noncurry_map__(&:join).flat_map { |t| t[:out] }
    end
  end

end

# Maybe Monad.
class Maybe < BasicObject

  @@chain_size = 0

  def initialize(value)
    @value = value
    @methods = {}
  end

  def inspect
    "< Maybe #{@value.class}, Chain: #{@methods.inspect} >"
  end

  def maybe
    ::Kernel.raise ::ArgumentError, "You are already Maybe!"
  end

  def method_missing(method, *args, &block)
    @@chain_size += 1
    @methods[@@chain_size] = {
      name: method,
      args: args,
      block: block,
    }
    self
  end

  def nil?
    self.().nil?
  end

  def empty?
    result = self.()
    if result.respond_to? :empty?
      result.empty?
    else
      result.nil? || (result == []) || (result == {}) || (result == '')
    end
  end

  def something?
    !empty?
  end

  def call
    begin
      value = @value.dup
    rescue ::TypeError
      value = @value
    end
    @methods.values.inject(value) do |result, method|
      begin
        result.send(method[:name], *method[:args], &method[:block])
      rescue ::NoMethodError => ex
        if result.nil?
          return nil
        else
          ::Kernel.raise ::NoMethodError, ex.message
        end
      end
    end
  end

end
