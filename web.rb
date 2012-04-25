require 'rubygems'  # allows for the loading of gems
require 'graphviz'  # this loads the ruby-graphviz gem


load 'dfa.rb'
load 'nfa.rb'

puts "Welcome, Enter the key words you wish to search for separated by space:"
keywords = gets.chomp
@nfa = NFA.new keywords.split(" ").to_a


#we have the states S, W, E, B
d = DFA.new([0], @nfa.final_states)
@table = @nfa.hash

d.transition do |s,a|
	#puts "s(#{s}) => a(#{a})"
  #puts "#{@table[s][a]}: " + @table.inspect
  #puts @table[s][a].to_s
  @table[s][a]
end

count = Hash.new(0)

puts ("\nEnter the text please:\n")

input = gets.chomp
text = input
input.gsub("\n", " ").chars.to_a.map do |a|
    if d.eat a
        count[@nfa.final_states_index[d.state]] = count[@nfa.final_states_index[d.state]] + 1
    end
end


puts("\nKey words accourances:\n")
count.each do |word, ocnum|
    puts word.to_s+" "+ocnum.to_s
end
puts

#visualizing the automat
# initialize new Graphviz graph
g = GraphViz::new( "structs", "type" => "graph" )
g[:rankdir] = "LR"

# set global node options
g.node[:color]    = "#ddaa66"
g.node[:style]    = "filled"
g.node[:shape]    = "circle"
g.node[:penwidth] = "1"
g.node[:fontname] = "Trebuchet MS"
g.node[:fontsize] = "8"
g.node[:fillcolor]= "#ffeecc"
g.node[:fontcolor]= "#775500"
g.node[:margin]   = "0.0"

# set global edge options
g.edge[:color]    = "#999999"
g.node[:shape]    = "circle"
g.edge[:weight]   = "1"
g.edge[:fontsize] = "6"
g.edge[:fontcolor]= "#444444"
g.edge[:fontname] = "Verdana"
g.edge[:dir]      = "forward"
g.edge[:arrowsize]= "0.5"


# adding nodes
@nfa.hash.each do |key, value|
    source_node_name = key.to_s

    # putting double circles around final states
    if @nfa.final_states.include?(key)
        g.add_nodes(source_node_name).shape = "doublecircle"
        
    end
    
    g.add_nodes(source_node_name).label = key.to_s 
    #connecting nodes with edges
    value.each do |edge_label, target_node| 
        target_node_name = target_node.to_s
        edge_label_str = edge_label.to_s
        g.add_edges(source_node_name, target_node_name).label = edge_label_str
    end

    
    
    
    default_node_name = @nfa.hash[key].default.to_s
    g.add_edges(source_node_name, default_node_name).label = "rest of alphapet"
end

    

g.output(:png => "webtest1.png" )



