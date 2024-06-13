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

