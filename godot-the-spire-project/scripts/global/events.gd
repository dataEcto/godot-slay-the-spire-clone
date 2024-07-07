extends Node

# Card-Related Events to Signal
# We pass the CardUI nodes as our parameters so
# We can get access to them from the CardTargetSelector node
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)


