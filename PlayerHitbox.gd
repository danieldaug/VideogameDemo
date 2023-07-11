extends Area2D

## Hitbox or 2D area that simulates damage taken by Player
##
## Contains one method that emits
## a signal to Player's main script (Player.gd) when commanded to do so
## by NPC when NPC hits Player's Hitbox

signal playerdmg(d)

func transfer_damage(damage,posit):
	emit_signal("playerdmg",damage,posit)
