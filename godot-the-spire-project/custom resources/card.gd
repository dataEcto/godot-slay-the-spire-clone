class_name Card

extends Resource

#Enum's based on Slay The Spire
enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target

# Resources are not just data containers 
# that can also have functions within them

# This function checks if we are aiming at a single target
func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY
