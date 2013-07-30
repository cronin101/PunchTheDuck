# PunchTheDuck
#### Instead of making languages better, why don't we make them worse?
##### In this tale, I slowly give Ruby *every* feature. Ever.
```ruby
require './functional_toolkit'

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
  String::prototype(:to_derp).set ->(this){ 'derp' }
  Fixnum::prototype(:to_derp).set ->(this){ '03rp'.to_i }
  Fixnum::prototype(:to_xvar).set ->(this){ 'x' + this.to_s }

  'herp'.to_derp
  #=> "derp"

# Maybe Monad

  (1..10).maybe.select(&:even?).select(&:odd?).first.to_derp.something?
  #=> False

  (1..10).maybe.select(&:even?).first.()
  #=> 2

# Putting it all together to create a horrible mess.

  (1..10)
    .maybe
    .select(&:even?)
    .select{ |num| num > 10 }
    .map(&add)
    .map { |func| func.(1) }
    .map(&:to_xvar).()
  #=> []

  (1..10)
    .maybe
    .select(&:even?)
    .select{ |num| num < 10 }
    .map(&add)
    .map { |func| func.(1) }
    .map(&:to_xvar).()
  #=> ["x3", "x5", "x7", "x9"]

```
