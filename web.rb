load 'dfa.rb'
require 'matrix'

#we have the states S, W, E, B
d = DFA.new('S', ['B'])

@table = Hash.new
@table = { "S" => Hash.new('S').merge({'w' => 'W'}),
           "W" => Hash.new('S').merge({'e' => 'E'}),
           "E" => Hash.new('S').merge({'b' => 'B'}),
           "B" => Hash.new('S').merge({'b' => 'B'})
         }

d.transition do |s,a|
  #puts "#{@table[s][a]}: " + @table.inspect
  #print @table[s][a]
  @table[s][a]
end

ary = ['a','w','e', 'b'].map do |a|
  d.eat a
end

puts ary.last

