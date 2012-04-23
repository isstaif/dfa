class DFA
  # d responds to call(state,input), returning the successive state.
  # It may do anything else that you want it to do; this is how transitional
  # actions are implemented.
  attr :d, true
  # Final states. Responds to include?(state)
  attr :finals, true
  # The initial state as provided to the constructor. This is for your
  # reference only (it's never used outside of the constructor.)
  attr :start
  # The current state.
  attr :state, true

  def initialize(s0, finals=[])
    @start = s0
    @state = @start
    @finals = finals
  end

  # Given an input symbol, transition the state machine according to the return
  # value of d, and return true if the now-current state is a final state, or
  # false otherwise.
  def eat(a)
    @state = @d.call(@state,a)
    final?
  end

  # Is the current state a final state?
  def final?
    @finals.include? @state
  end

  # Syntactic sugar for defining d. The block will be called with the current
  # state and input when eat(a) is called.
  def transition(&block)
    @d = block
  end
end

