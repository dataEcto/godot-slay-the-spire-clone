# This is the basis of all of our card states!
# note this is not a state machine
class_name CardState
extends Node

#Aiming will be covered later
enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

#Signal that will let us transition to another state
signal transition_requested(from:CardState, to: State)

#A variable that can be assigned to the editor
@export var state: State

#Get a reference to the card ui node
# so we can change the color and updating the label within the state scripts
var card_ui: CardUI

#These two functions will be called when entering/exit a state
func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
#2 more Callback Functions the state can use
# with their corresponding InputEvents passed on as a parameter
func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

# 2 more callbacks for mouse entering and exiting (i assume the cursor entering an area 2d)
func on_mouse_entered() -> void:
	pass
	
func on_mouse_exited() -> void:
	pass
