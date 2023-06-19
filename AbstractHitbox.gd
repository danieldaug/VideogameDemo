extends Node

## Abstract  Hitbox or 2D area that simulates damage taken by other
## character
##
## Contains one method that emits a signal when commanded to do so
## by other character that delivers damage

#creates signal "dmg"
signal dmg(d)

#receives command to transfer damage, then emits signal
#to main character code holding hitbox
func transfer_damage(damage,posit):
	emit_signal("dmg",damage,posit)
