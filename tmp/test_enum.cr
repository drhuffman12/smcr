# Code Example

enum FooBar
end

FooBar.values

enum Color
  Red
  Green
  Blue
end

p! Color
p! Color.class

p! Color::Red
p! Color::Red.class

p! Color.names
p! Color.names.first.class
p! Color.values
p! Color.values.first.class

require "json"

class Foo(T)
  include JSON::Serializable

  property states_allowed : Array(T) = T.values
  property state : T

  def self.state_class
    T
  end

  def initialize(@state : T)
  end
end

f = Foo(Color).new(state: Color::Red)

c = Foo(Color).state_class

puts
p! f
p! c
p! f.to_json
p! Foo(Color).from_json(f.to_json)
puts

# OUTPUT

<<-OUTPUT

Color # => Color
Color.class # => Class
Color::Red # => Red
Color::Red.class # => Color
Color.names # => ["Red", "Green", "Blue"]
Color.names.first.class # => String
Color.values # => [Red, Green, Blue]
Color.values.first.class # => Color
f # => #<Foo(Color):0x7f0dc848cdc0 @states_allowed=[Red, Green, Blue], @state=Red>
f.to_json # => "{"states_allowed":["red","green","blue"],"state":"red"}"
Foo(Color).from_json(f.to_json) # => #<Foo(Color):0x7f0dc848cd20 @states_allowed=[Red, Green, Blue], @state=Red>

OUTPUT
