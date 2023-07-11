extends Area2D

## Hitbox or 2D area that simulates damage taken by NPC
##
## Contains one method that emits
## a signal to NPC's main script (NPC.gd) when commanded to do so
## by Player when Player hits NPC's Hitbox

signal dmg(d)

func transfer_damage(damage,posit):
	emit_signal("dmg",damage,posit)
