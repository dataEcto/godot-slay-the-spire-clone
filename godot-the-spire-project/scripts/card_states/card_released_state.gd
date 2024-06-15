extends CardState

# a bool that checks if a card has been played
var played: bool

func enter() -> void:
	card_ui_node.color.color = Color.DARK_VIOLET
	card_ui_node.state.text = "RELEASED STATE"
	
	played = false
	# check if our array of Area2d is empty or not. 
	# if it isnt, it means we are over the area 2d drop zone	
	if not card_ui_node.targets.is_empty():
		played = true
		print ("Play card for target(s)", card_ui_node.targets)

# On input call back...
func on_input(_event:InputEvent) -> void:
	# Check if we played a card or not.
	# If we did, and we recieved input, we dont really care
	# because the card has been played and thus its purpose has been done
	if played:
		return
	# but if we HAVENT played it yet + we recieved an input (right click probably)
	# We go back to our base state
	# Note that we do this on input instead of the enter state bc enter
	# will always run all the way through
	# THATS why we dont have an else if in enter. so treat this as an else if
	transition_requested.emit(self,CardState.State.BASE)
	
