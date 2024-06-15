extends CardState

func enter() -> void:
	# Debug Purposes
	card_ui_node.color.color = Color.ORANGE
	card_ui_node.state.text = "CLICKED STATE"
	
	# Enable the monitoring of the drop point detector that we have
	# on the card ui.
	# We do this here because we are now starting interactions with the card
	# when we click on it
	card_ui_node.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	# if we are moving the mouse, we are dragging.
	if event is InputEventMouseMotion:
		#THUS transition to the Dragging State
		transition_requested.emit(self,CardState.State.DRAGGING)
