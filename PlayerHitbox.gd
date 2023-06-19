extends Area2D

## Hitbox or 2D area that simulates damage taken by Player
##
## Contains one method (inherited by AbstractHitbox) that emits
## a signal to Player's main script (Player.gd) when commanded to do so
## by NPC when NPC hits Player's Hitbox

signal playerdmg(d)


#INHERITANCE
var parent=load("res://AbstractMovingCharacter.gd").new()

#INHERITED FUNCTION
func transfer_damage(damage,posit):
	emit_signal("playerdmg",damage,posit)
