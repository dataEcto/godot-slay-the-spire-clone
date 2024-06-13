#give it a class name so we can access this anywhere else in code...
class_name CardStateMachine
extends Node

#In the inspector, we set our card state
# Our initial_state variable will always be something that inherits from CardState
# so basically, all of our Card State Notes have a script thats inherits from CardState
# Thus it is a valid input for Initial_state
@export var initial_state: CardState

# 2 variables to store the current state 
# and a Dictionary that stores all the avaiable states
var current_state: CardState
var states_dict: = {}

# We have an Init function which we call from the card_ui
func init(card: CardUI) -> void:
	#First, we iterate through all of the children of the state machine
	for child in get_children():
		#We check if the current child is a card state or not
		if child is CardState:
			# and if it is,we add it to the dictionary of all the states we have
			states_dict[child.state] = child
			# and connect the transition requested signal (from Card_ui) to our own function
			# which will handle the transition
			child.transition_requested.connect(_on_transition_requested)
			# Then, we pass the card ui reference to the state itself
			child.card_ui = card
			
	# Then, if we have an initial_state, we enter it:
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# We have 2 callback functions for Input and GUI Input
# We declare the variable we need is an Event Variable, and we return void
func on_input(event: InputEvent) -> void:
	#We check if we ARE in a state or not...
	if current_state:
		#and if we are, we can call that state's callback functions
		current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)

func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()

func on_mouse_exit() -> void:
	if current_state:
		current_state.on_mouse_exited()

# This function will handle state transitions
func _on_transition_requested(from: CardState, to:CardState.State) -> void:
	# First, we need to check if the "(going) from" state and the "Current" state 
	# is equal or not.
	# If they aren't the same...well, logically, thats impossible. 
	# But codewise it CAN happen.
	if from != current_state:
		return
		
	# after that, store we store a reference to our new state
	# which comes from our dictionary of states
	var new_state: CardState = states_dict[to]
	
	# if we dont have states in our dictionary, we just return
	if not new_state:
		return
		
	# Otherwise, if a new state does exist...
	# First, we must exit the current state. 
	# Remember we set up an exit function within card_state.gd
	# Hold CTRL and press on exit to see the origin
	if current_state:
		current_state.exit()
	
	# Then FINALLY we can enter the new state
	# ands et our current state to this new state
	new_state.enter()
	current_state = new_state
	
