# This code is responsible for listening
# for signal reparent_requested
class_name Hand
extends HBoxContainer

func _ready () -> void:
	# Iterate through all the children of this HBoxContainer
	for child in get_children():
		# Assign a variable to the current children as Card UI static type
		var card_ui_node := child as CardUI
		# connect the signal to our own function, declared below
		card_ui_node.reparent_requested.connect(_on_card_ui_reparent_requested)

# a function that checks for when a reparent is requested 
# taking in a parameter of a child with the cardui static type
func _on_card_ui_reparent_requested(child: CardUI) -> void:
	# Put said child back into our HBoxcontainer, aka ourselves
	child.reparent(self)
