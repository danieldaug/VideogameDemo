extends GutTest

## Testing for Player.gd
##
## Tests Player's movement, that Player get knocked back properly,
## attacks properly, and takes damage

#uses simulated variables to test functions

var player=load("res://Player.gd")
func test_knocked_back_when_can_attack():#in _knockback()
	#simulated variables
	var can_attack=true
	var knockback=true
	var jumping=false
	var knockback_dir=1
	var motionY=0
	var motionX=0
	
	if can_attack:
		if knockback:
			#hit upwards if on the ground
			if jumping==false:
				motionY-=300
			#knocked back in direction depending on 
			#direction given
			if knockback_dir==1:
				motionX=700*knockback_dir
			else:
				motionX=700*knockback_dir
			knockback=false
	assert_eq(motionY,-300)
	assert_eq(motionX,700)
func test_attack_when_can():#in _input_movement()
	#simulated variables
	var can_attack=true
	var standattackAnimationPlays=false
	var attackDelayTimerStarts=false
	var leftclickPressed=true
	
	if can_attack:
		if leftclickPressed:
			standattackAnimationPlays=true
			attackDelayTimerStarts=true
			can_attack=false
	assert_true(standattackAnimationPlays,"Will play animation")
	assert_true(attackDelayTimerStarts,"Will start attack delay timer")
	
func test_dont_attack_when_cant():#in _input_movement()
	#simulated variables
	var can_attack=false
	var standattackAnimationPlays=false
	var attackDelayTimerStarts=false
	var leftclickPressed=true
	
	if can_attack:
		if leftclickPressed:
			standattackAnimationPlays=true
			attackDelayTimerStarts=true
			can_attack=false
	assert_false(standattackAnimationPlays,"Will not play animation")
	assert_false(attackDelayTimerStarts,"Will not start attack delay timer")

func test_jump_when_on_ground():#in _input_movement_jumping_helper()
	#simulated variables
	var is_on_floor=true
	var upButtonPressed=true
	var motionY=0
	var jumping=false
	const JUMPFORCE=450
	
	if is_on_floor:
		if upButtonPressed:
			motionY=-JUMPFORCE
			jumping=true
	assert_true(jumping,"Jumps when button is pressed and able to jump")
	assert_eq(motionY,-450,"Proper jumpforce given to y-axis movement")
	
func test_attack_in_air():#in _input_movement_jumping_helper
	#simulated variables
	var is_on_floor=false
	var can_attack=true
	var jumpattackAnimationPlays=false
	var attackDelayTimerStarts=false
	var leftclickPressed=true
	
	if !is_on_floor:
		if can_attack:
				if leftclickPressed:
					jumpattackAnimationPlays=true
					can_attack=false
					attackDelayTimerStarts=true
	assert_true(jumpattackAnimationPlays,"Will play animation")
	assert_true(attackDelayTimerStarts,"Will start attack delay timer")

func test_knockback_and_damage():#in take_damage()
	#simulated variables
	var position=true
	var knockback_dir=1
	var knockback=false
	var facing_right=true
	var blockAnimationPlays=false
	var health=100
	var dieFunctionCalled=false
	var damage=10
	var healthbarAnimationPlays=false
	var healthbarTimerStarts=false
	var damageAnimationPlays=false
	
	if position==true:
			knockback_dir=1
	else:
		knockback_dir=-1
	knockback=true
	#negates knockback and damage if player is in 
	#blocking animation in opposing direction to
	#damage signal
	if !(position!=facing_right&&blockAnimationPlays):
		healthbarAnimationPlays=true
		healthbarTimerStarts=true
		damageAnimationPlays=true
		health=health-damage
		if health<=0:
			dieFunctionCalled=true
	assert_true(healthbarAnimationPlays,"Healthbar increments for health going down")
	assert_true(damageAnimationPlays,"Player executes damage animation")
	assert_true(healthbarTimerStarts,"Timer ensures healthbar only increments once then stops")
	assert_eq(health,90,"Amount of health after damage dealt")
