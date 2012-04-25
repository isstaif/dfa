load "dfa.rb"
class NFA

	attr :hash
	attr :final_states
  attr :final_states_index

  def initialize(keywords)
 		@hash = {0 => Hash.new([0])}
 		@final_states = []
 		@final_states_index = Hash.new
		keywords.each do |keyword|
			add_keyword_nfa keyword
		end
		normalize
  end

  def to_dfa
	d = DFA.new([0], @final_states)
	d.transition do |s,a|
		@hash[s][a]
	end
	d
  end


  def add_keyword_nfa(keyword)
		offset = @hash.length - 1
		(0..keyword.length).to_a.each do |i|
			case i
				when 0
					@hash[0] = @hash[0].merge(keyword[0] => [0, offset + 1])
				when keyword.length
					@hash = @hash.merge({ (offset + i) => Hash.new([-1]) })
					@final_states.push [offset + i]
					@final_states_index	= @final_states_index.merge  [offset + i] => keyword
					#@final_states_output_index.merge
				else
					@hash = @hash.merge({ (offset + i) => Hash.new([-1]).merge(keyword[i] => [offset + i+1]) })
			end

		end
	end

	def normalize
	    @hash = @hash.merge [0] => @hash[0]
		
		@hash.each do |key, value|
			bombing key
			unless key == [0]
			    @hash.delete key
			end
		end
		@hash.delete 0
		tmp = []
		@final_states.each do |state|		    
		    unless state.length == 1
		        tmp = tmp.push state
		    end
		end
		@final_states = tmp

	end


	def mergeing(array_of_states)

		@hash = @hash.merge array_of_states => Hash.new

		@hash[array_of_states].default = []
		array_of_states.each do |s|
			@hash[array_of_states].default.concat(@hash[s].default).delete(-1)
		end

		('a'..'z').to_a.each do |a|
			entry_condition = false
			array_of_states.each do |s|
				entry_condition  = entry_condition  || @hash[s].has_key?(a)
			end

			if entry_condition
				@hash[array_of_states] = @hash[array_of_states].merge(a => Array.new)
				array_of_states.each do |s|
					@hash[array_of_states][a].concat(@hash[s][a]).delete(-1)
				end
			end
		end

	end

	def bombing (state)
		@hash[state].each do |letter, array_of_transitions_for_letter|
			if array_of_transitions_for_letter.length > 1
				unless @hash.has_key? array_of_transitions_for_letter

					is_final_state = false
					final_state_key =""

					@final_states.each do |final_state|
						#puts "Compared #{array_of_transitions_for_letter} with #{final_state}"
						if (final_state.length == 1) && (array_of_transitions_for_letter.include?(final_state.first))
							#puts "\ttrue"
							is_final_state = true
							final_state_key = final_state
						end
					end

					if is_final_state
						@final_states.push array_of_transitions_for_letter
						@final_states_index	= @final_states_index.merge  array_of_transitions_for_letter => @final_states_index[final_state_key]
					end

					mergeing array_of_transitions_for_letter
					bombing array_of_transitions_for_letter
				end
			end
		end
	end
end
