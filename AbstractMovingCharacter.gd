extends Node

## Abstract class for any character's main script controlling all 
##movements and interactions
##
## Contains abstract method take_damage() and concrete methods,
## _die() and _movement_and_gravity


const UP= Vector2(0,-1)
const GRAVITY= 30
const MAXFALLSPEED=200
const MAXSPEED=100
const JUMPFORCE=450
const ACCEL=15
var isJumping=false
var motion=Vector2()
var health=100
var facingRight=true
var knockbackDir=Vector2()
var knockbackEnabled=false


#character response to receiving damage signal
#ABSTRACT
func take_damage(damage,direction):
	pass

#character disappears when dead
func _die():
	#removes "node" or object as well as everything connected
	#to object
	queue_free()

#basic physics and gravity
func _movement_and_gravity():
	motion.y+=GRAVITY
	if motion.y>MAXFALLSPEED:
		motion.y=MAXFALLSPEED
	#prevents motion on x-axis from exceeding MAXSPEED
	motion.x=clamp(motion.x,-MAXSPEED,MAXSPEED)
	


