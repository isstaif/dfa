load 'dfa.rb'

keyword = "web"

@nfa = Hash.new

#an nfa
@nfa = {
  0 => Hash.new([0]).merge('w' => [0,1]),
  1 => Hash.new([-1]).merge('e' => [2]),
  2 => Hash.new([-1]).merge('b' => [3]),
  3 => Hash.new([-1])
}

#initializing dfa
@dfa = Hash.new

@nfa.each do |state, transitions|
  #puts "#{state} #{transitions}, default #{transitions.default}"
  @dfa = @dfa.merge({state => 0})
end

puts @dfa

#we have the states S, W, E, B
d = DFA.new(0, [3])

@table = Hash.new
@table = { 0 => Hash.new(0).merge({'w' => 1}),
           1 => Hash.new(0).merge({'e' => 2}),
           2 => Hash.new(0).merge({'b' => 3}),
           3 => Hash.new(0).merge({'b' => 3})
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

