extends CardState

# This will be used to check if the mouse is below
# this treshold (in pixels) while aiming, 
# and if it is, we will
# set it up so the mouse snapsback.
# Note that the game window is pretty small, so if I wanted to edit this...
const MOUSE_Y_SNAPBACK_TRESHOLD := 138

func enter() -> void:
	# Debugging purposes
	card_ui_node.color.color = Color.WEB_PURPLE
	card_ui_node.state.text = "AIMING STATE"
	# We clear this array to make sure that 
	# We will only target Enemies
	card_ui_node.targets.clear()
	
	# Calculate the Offset of the card so that
	# When we start aiming, we move the Card to the center of the hand
	
	# parent hasnt been declared yet as of writing but will be done so soon
	var offset := Vector2(card_ui_node.parent.size.x/2, -card_ui_node.size.y/2)
	
	offset.x -= card_ui_node.size.x / 2
	# This function will be made later to animate the card to the center 
	# of the hand
	card_ui_node._animate_to_position(card_ui_node.global_position * offset,0.2)
	
	# Finally, we grab the drop point dector to set its monitoring to false
	# Because when we are aiming, we dont care about moving the card to the drop card area
#   # we want it false so that we dont get its card drop area as a target
	card_ui_node.drop_point_detector.monitoring = false
	
	# Notify the event bus
	# to fire a signal and to start it
	# So that any subscribers can be made aware of it
	# Remember we set Card ui node as a parameter in the Events script
	Events.card_aim_started.emit(card_ui_node)

func exit() -> void:
	Events.card_aim_ended.emit(card_ui_node)

# The aiming happens here, on input
func on_input(event: InputEvent) -> void:
	# Define some events to look out for
	
	# This event takes our event parameter to check if our mouse is in motion
	var mouse_motion := event is InputEventMouseMotion
	
	# And this checks if our mouse is below the threshold
	var mouse_at_bottom := card_ui_node.get_global_mouse_position(). y > MOUSE_Y_SNAPBACK_TRESHOLD
	
	# If the above events are called together OR  we cancel with right click
	# we go back to our base state
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		# a note to self- i am very much used to how in Unity, this would probably be like emit.transition_requested(self, CardState.State.BASE)
		transition_requested.emit(self, CardState.State.BASE)
	# OTHERWISE if we finish aiming we set the input as handled
	# So that no one else accidentaly picks up the input
	# And go to our released state
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
			get_viewport().set_input_as_handled()
			transition_requested.emit(self,CardState.State.RELEASED)
	
