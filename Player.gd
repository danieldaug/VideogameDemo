extends CharacterBody2D

## Player object's main script controlling all movements and
## interactions
##
## Uses input by user in order to move Player on screen in different
## directions, swing sword, and block with shield. Has many "nodes"
## or objects attached including animated PLayerSprite, PlayerHitbox (see
## in PlayerHitbox.gd), SwordRange 2D area to deliver damage to NPCs
## when sword is swung, PlayerContact to simulate Player's solid
## physical body, Camera2D to follow Player, PlayerAnimation,
## AttackDelay timer, HealthIncrement timer, Healthbar sprite, and 
## HealthbarAnimation
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

#own variables tracking whether the player is able
#to attack and telling whether to increment the health
#bar due to damage
var canAttack=true
var healthbarMove=false

func _movement_and_gravity():
	motion.y+=GRAVITY
	if motion.y>MAXFALLSPEED:
		motion.y=MAXFALLSPEED
	#prevents motion on x-axis from exceeding MAXSPEED
	motion.x=clamp(motion.x,-MAXSPEED,MAXSPEED)

func _die():
	queue_free()

func take_damage(damage,direction):
	#set knockback direction based on enemy position
	if direction==true:
			knockbackDir=1
	else:
		knockbackDir=-1
	knockbackEnabled=true
	#negates knockback and damage if player is in 
	#blocking animation in opposing direction to
	#damage signal
	if !(direction!=facingRight&&$PlayerAnimation.current_animation=="block"):
		#starts health bar animation again
		$HealthbarAnimation.play()
		#sets timer before pausing animation to stay at indicated
		#health
		$HealthIncrement.start()
		$PlayerAnimation.play("damage")
		health=health-damage
		if health<=0:
			_die()

func _ready():
	#connecting other "nodes" in the framework so that
	#the player object may interact with them
	var hitboxArea=get_node("PlayerHitbox")
	hitboxArea.connect("playerdmg",Callable(self,"take_damage"))
	var attackTimer=get_node("AttackDelay")
	var healthTimer=get_node("HealthIncrement")
	#set up healthbar animation so it is ready to increment
	$HealthbarAnimation.play("healthbar")
	$HealthbarAnimation.pause()

#function runs repeatedly while program in running
#delta ensures repeated running speed is consistent across
#all computers
func _physics_process(delta):
	#stops health bar increment
	if healthbarMove:
		$HealthbarAnimation.pause()
		healthbarMove=false
	_movement_and_gravity()
	#faces sprite left/right for direction moving
	if facingRight==true:
		$PlayerSprite.scale.x=1
	else:
		$PlayerSprite.scale.x=-1
	_knockback()
	_input_movement()

#check if player can attack and is being knocked back
func _knockback():
	if canAttack:
		if knockbackEnabled:
			#hit upwards if on the ground
			if isJumping==false:
				motion.y-=300
			#knocked back in direction depending on 
			#direction given
			if knockbackDir==1:
				motion.x=700*knockbackDir
			else:
				motion.x=700*knockbackDir
			knockbackEnabled=false

func _input_movement():
	#user input commands for movement
	if Input.is_action_pressed("left"):
		motion.x-=ACCEL
		facingRight=false
		if is_on_floor():
			#walk if other animations are not ongoing
			if !$PlayerAnimation.current_animation=="standattack"&&!$PlayerAnimation.current_animation=="damage":
				$PlayerAnimation.play("walk")
	elif Input.is_action_pressed("right"):
		motion.x+=ACCEL
		facingRight=true
		if is_on_floor():
			if !$PlayerAnimation.current_animation=="standattack":
				$PlayerAnimation.play("walk")
	else:
		#lerp slows down movement speed to 0 when
		#there is no movement input
		motion.x=lerp(motion.x,0.0,0.25)
		if is_on_floor():
			if !$PlayerAnimation.current_animation=="standattack"&&!$PlayerAnimation.current_animation=="damage":
				$PlayerAnimation.play("idle")
			if Input.is_action_pressed("block"):
				if is_on_floor():
					$PlayerAnimation.play("block")
			if canAttack:
				if Input.is_action_just_pressed("hit"):
					$PlayerAnimation.play("standattack")
					#attack triggers timer before able to 
					#attack again
					canAttack=false
					$AttackDelay.start()
	_input_movement_jumping_helper()
	#adjust velocity to avoid collisions
	set_velocity(motion)
	#upward vector for up direction
	set_up_direction(UP)
	#allows player to move along collided floor object
	move_and_slide()
	motion=velocity

func _input_movement_jumping_helper():
	#actions for while Player is airborne
	if !is_on_floor():
		if isJumping:
			if $PlayerAnimation.current_animation!="damage":
				$PlayerAnimation.play("jump")
			isJumping=false
		if canAttack:
			if Input.is_action_just_pressed("hit"):
				$PlayerAnimation.play("jumpattack")
				canAttack=false
				$AttackDelay.start()
	#only jump if on the ground
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			motion.y=-JUMPFORCE
			isJumping=true

func _on_sword_range_area_entered(area):
	#built in signal checks if sword area hits npc hitbox area
	#(sword area only active during attack animations)
	if area.is_in_group("npchitbox"):
		#command npc's hitbox to do transfer damage command
		area.transfer_damage(10,facingRight)


func _on_attack_delay_timeout():
	#Can attack again once timer ends (0.3 sec)
	canAttack=true


func _on_health_increment_timeout():
	#stops healthbar once timer ends (0.1 sec)
	healthbarMove=true
	


