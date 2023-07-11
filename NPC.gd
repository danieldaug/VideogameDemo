extends CharacterBody2D

## NPC object's main script controlling all movements and
## interactions
##
## Uses Player location in order to move NPC on screen in different
## directions. Has many "nodes" or objects attached including animated
## NPCSprite, NPCHitbox (see in NPCHitbox.gd), NPCContact to simulate 
## NPC's solid physical body, NPCAnimation, and Movement timer
## Nodes that are explicitly manipulated in this script are connected
## in the _ready() method, which executes once when the program starts

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

#own variables to determine which action is currently going
#and shows the player location
var action=3
var playerLocation=0

func _movement_and_gravity():
	motion.y+=GRAVITY
	if motion.y>MAXFALLSPEED:
		motion.y=MAXFALLSPEED
	#prevents motion on x-axis from exceeding MAXSPEED
	motion.x=clamp(motion.x,-MAXSPEED,MAXSPEED)

func _die():
	queue_free()

func take_damage(damage,direction):
	#set knockback direction based on player position
	if direction==true:
		knockbackDir=1
	else:
		knockbackDir=-1
	knockbackEnabled=true
	$NPCAnimation.play("damage")
	health=health-damage	
	if health<=0:
		_die()

func _ready():
	#connecting other "nodes" in the framework so that
	#the npc object may interact with them
	var MovementTimer=get_node("MovementTimer")
	MovementTimer.connect("timeout",Callable(self,"on_moving_timeout"))
	var sprite=get_node("NPCSprite")
	var hitboxArea=sprite.get_node("NPCHitbox")
	hitboxArea.connect("dmg",Callable(self,"take_damage"))

func _process(delta):
	#just to reset NPC animations
	if !$NPCAnimation.is_playing():
		$NPCAnimation.play("RESET")

#function runs repeatedly while program in running
#delta ensures repeated running speed is consistent across
#all computers
func _physics_process(delta):
	_movement_and_gravity()
	#faces sprite left/right for direction moving
	if facingRight==true:
		$NPCSprite.scale.x=-1
	else:
		$NPCSprite.scale.x=1
	_knockback()
	_move_direction()
	
#check if npc is being knocked back
func _knockback():
	if knockbackEnabled:
		motion.y-=200
		if knockbackDir==1:
			motion.x=700*knockbackDir
		else:
			motion.x=700*knockbackDir
		knockbackEnabled=false

func _on_npc_hitbox_area_entered(area):
	#if player is touched by npc, player's hitbox
	#is commanded to emit damage signal
	if area.is_in_group("playerhitbox"):
		area.transfer_damage(10,facingRight)
		$NPCAnimation.play("attack")

func on_moving_timeout():
	#follows player object by comparing positions in x-axis
	playerLocation=get_parent().get_node("Player").global_position.x
	if playerLocation>=self.global_position.x:
		action=1
	elif playerLocation<self.global_position.x:
		action=0

func _move_direction():
	#automated actions as opposed to player's user input actions
	#left motion
	if action==0:
		motion.x-=ACCEL
		facingRight=false
		if !$NPCAnimation.current_animation=="damage"&&!$NPCAnimation.current_animation=="attack":
			$NPCAnimation.play("idle")
	#right motion
	elif action==1:
		motion.x+=ACCEL
		facingRight=true
		if !$NPCAnimation.current_animation=="damage"&&!$NPCAnimation.current_animation=="attack":
			$NPCAnimation.play("idle")
	#jump motion
	elif is_on_floor():
		if action==2:
			motion.y=-JUMPFORCE
			$NPCAnimation.play("jump")
	else:
		#lerp slows down movement speed to 0 when
		#there is no movement input
		motion.x=lerp(motion.x,0.0,0.25)
		$NPCAnimation.play("idle")
	#adjust velocity to avoid collisions
	set_velocity(motion)
	#upward vector for up direction
	set_up_direction(UP)
	#allows player to move along collided floor object
	move_and_slide()
	motion=velocity



