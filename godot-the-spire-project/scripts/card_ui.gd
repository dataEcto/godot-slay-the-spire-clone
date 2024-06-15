# we assign a class name to the script
# so that it is a recognize able static type
# I recall doing this in another game, i think the heart platformer
# so that i can get a resource with variables in them
class_name CardUI
extends Control

# We make a signal that reparent's the card away from the HBoxContainer
# Allowing for that drag and drop effect
# right now it doesn't actually do anything
signal reparent_requested(which_card_ui: CardUI)

# Make reference to some Inspector Variables
@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector = $DropPointDetector

# This array of nodes will hold all of the current targets for the card
@onready var targets: Array[Node] = []

#Access our card state machine
# "The 'as' operator casts the instance to the given type, 
# it returns null if the type is incompatible."
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine

# Once we boot up, we initialize the state machine using its function
func _ready() -> void:
	# Pass this card ui as a parameter so we can have the reference
	# to card ui (as card_ui_node)
	card_state_machine.init(self)

# Callback functions for input and on gui input
# in a way, basically waking up those functions within state machine using
# this allback function.
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exit()

# make sure to hook up the callback functions
# to the proper signals
# via Scene > Card UI > Node > signals > connect the 3 and youll see a green door
# _ready and _input are inherited from nodes, no need to connect those


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	# When we first enter the Area2D, check if the Area2D is in our array.
	# If not, we add it
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	# When we exit another area with the drop point detector
	# We erase that area from our current array
	targets.erase(area)
