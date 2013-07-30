```ruby
require './functional_toolkit'

# Partially-applied-function composition
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

# Function prototype definition
  String::prototype(:to_derp).set ->{ 'derp' }

  'herp'.to_derp
  #=> "derp"

# Maybe Monad
  Fixnum::prototype(:to_derp).set ->{ '03rp'.to_i }

  (1..10).maybe.select(&:even?).select(&:odd?).first.to_derp.something?
  #=> False

  (1..10).maybe.select(&:even?).first.!
  #=> 2
```
