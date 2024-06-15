extends CardState

func enter() -> void:
	# Because this is the first state, we are dependent on 
	# the status of the Card UI node.
	# We check if it is ready.
	if not card_ui_node.is_node_ready():
		# If not, we wait for it to be ready
		# Due to how Godot works, child nodes load first before parent nodes
		await card_ui_node.ready
	
	# First, we request to reparent the card ui if we enter the base state
	# Because, for example, we start Dragging the card but we cancel out the movement
	# Then we'd want the card to go back to our "hand"
	card_ui_node.reparent_requested.emit(card_ui_node)
	
	# Change the color and text for debugging purposes
	card_ui_node.color.color = Color.WEB_GREEN
	card_ui_node.state.text = "BASE STATE"
		
	# Reset the pivot offset of the card
	# This pivot offset is used when we drag the card, so we dont want
	# the top left of the card to snap to the mouse cursor
	# Rather, we want it to be on the middle of the mouse.
	# We need to set the pivot offset, and also reset it whenever we go back to base
	card_ui_node.pivot_offset = Vector2.ZERO

# This function is how we enter the Clicked state
func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		# Calculate the pivot offset so that we can drag the card from its Base
		# position onto the Mouse Position
		card_ui_node.pivot_offset = card_ui_node.get_global_mouse_position() - card_ui_node.global_position
		# Then we request to go to the next state - Clicked
		# Remember transistion_requested is a custom function we made
		# We emit it with the state we are in, which is just base/self, then
		transition_requested.emit(self, CardState.State.CLICKED)
