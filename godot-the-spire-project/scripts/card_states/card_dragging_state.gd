extends CardState

# This is a  float
const DRAG_MINIMUM_TRESHHOLD := 0.05

var minimum_drag_time_elasped := false

# We need to reparent the CardUI from our Hand/Hbox
# So that we can freely move our Card UI
func enter() -> void:
	# We need to get access to our Battle UI.
	# Theoretically we could get CardUI to get its parent, Hand, and then
	# Hand can get its parent, Battle UI
	# But its not a best practice simply because it relies too much on our current set up
	# Where everything is parented the exact way it is.
	# The easiest fix is to set BattleUI to a group (in this case "ui_layer")
	# and then use a method to grab that group and get battle ui. 
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui_node.reparent(ui_layer)
		
	# Debuging 
	card_ui_node.color.color = Color.NAVY_BLUE
	card_ui_node.state.text = "DRAGGING STATE"
	
	minimum_drag_time_elasped = false
	# the false, we specify the timer should pause when the scene is paused too
	var treshold_timer := get_tree().create_timer(DRAG_MINIMUM_TRESHHOLD,false)
	# When the timer runs out of time, we make minimum_drag_time_elasped true
	treshold_timer.timeout.connect(func(): minimum_drag_time_elasped = true)


# Transitioning to Release OR Base state.
func on_input(event: InputEvent) -> void:
	# Check if the card that is selected is a single target card
	var single_targeted := card_ui_node.cardInfo.is_single_targeted()
	# This checks if our mouse is moving
	# By checking if the event we pass through is an Input Mouse motion
	var mouse_motion:= event is InputEventMouseMotion
	# This checks if we canceled by pressing right click
	var cancel = event.is_action_pressed("right_mouse")
	# This checks if we confirmed with left click
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	# Simple if Statement.
	# Note that the array will only ever detect Card Drop Area.
	# First of all, we haven't even started aiming, so we can't detect enemies
	# Second of all, a Card's DropPointDetector only detects the Card Drop Area
	if single_targeted and mouse_motion and card_ui_node.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return

	#If we move the mouse...
	if mouse_motion:
		#update the global position so it follows the mouse cursor
		# We subtract the pivot offset here
		card_ui_node.global_position = card_ui_node.get_global_mouse_position() - card_ui_node.pivot_offset
	
	#If we cancel our mouse movement
	if cancel:
		#Go back to Base State
		transition_requested.emit(self, CardState.State.BASE)
	#but otherwise, if we confirm ...
	elif minimum_drag_time_elasped and confirm:
		# Set it so that we cant spam input to grab the card again
		get_viewport().set_input_as_handled()
		# Move to the released state
		transition_requested.emit(self, CardState.State.RELEASED)
