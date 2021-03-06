![](http://tetgames.com/sites/default/files/S/super-duck-punch-screenshot.png)
# PunchTheDuck
#### Instead of making languages better, why don't we make them worse?
##### In this tale, I slowly give Ruby *every* feature. Ever.
```ruby
require './functional_toolkit'

# Mapping with parallelism (for simple block maps)
  Benchmark.realtime { (1..100).map { `curl http://www.google.co.uk` } }
  #=> 7.386405
  
  Benchmark.realtime { (1..100).pmap { `curl http://www.google.co.uk` } }
  #=> 0.60273

# Partially-applied-function composition.
  add = ->(x, y){x + y}

  add_one = add.(1)

  six = add_one.(5)

  two_to_eleven = (1..10).map(&add_one)

  # Let's do something crazy.
  (1..10)
    .map(&add)
    .map { |f| f.(1) }

  ([add]*10)
    .map { |f| f.(1) }
    .map { |g| g.(2) }

# Function prototype definition.
  String::prototype(:to_derp).set ->{ 'derp' }
  Fixnum::prototype(:to_derp).set ->{ '03rp'.to_i }
  Fixnum::prototype(:to_xvar).set ->{ 'x' + this.to_s }

  'herp'.to_derp
  #=> "derp"

# Maybe Monad
  (1..10)
    .maybe
    .select(&:even?)
    .select(&:odd?)
    .first
    .to_derp
    .something?
  #=> False

  (1..10)
    .maybe
    .select(&:even?)
    .first
    .()
  #=> 2

# Putting it all together to create a horrible mess.

  (1..10)
    .maybe
    .select(&:even?)
    .select{ |num| num > 10 }
    .map(&add)
    .map { |func| func.(1) }
    .pmap(&:to_xvar).()
  #=> []

  (1..10)
    .maybe
    .select(&:even?)
    .select{ |num| num < 10 }
    .map(&add)
    .map { |func| func.(1) }
    .pmap(&:to_xvar).()
  #=> ["x3", "x5", "x7", "x9"]

```
