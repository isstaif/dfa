load 'dfa.rb'
load 'nfa.rb'

@nfa = NFA.new ["web","and"]

puts @nfa.hash

puts @nfa.final_states.to_s

#we have the states S, W, E, B
d = DFA.new([0], @nfa.final_states)
@table = @nfa.hash

d.transition do |s,a|
	#puts "s(#{s}) => a(#{a})"
  #puts "#{@table[s][a]}: " + @table.inspect
  #puts @table[s][a].to_s
  @table[s][a]
end

input = ['a','n','d', 'b','w','e'].map do |a|
  if d.eat a
  	puts d.state.to_s
 	end
end

