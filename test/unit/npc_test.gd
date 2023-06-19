extends GutTest

## Testing for NPC.gd
##
## Tests NPC's movement and player tracking

#uses simulated variables to test functions
func test_move_left_on_action_0():#in _move_direction()
	#simulated variables
	var action=0
	var motionX=0
	var motionY=0
	var isOnFloor=true
	var facingRight=true
	var standattackAnimationPlays=false
	var damageAnimationPlays=false
	var attackAnimationPlays=false
	var jumpAnimationPlays=false
	var walkAnimationPlays=false
	const JUMPFORCE=450
	const ACCEL=15
	
	for i in range(3):
		if action==0:
			motionX-=ACCEL
			facingRight=false
			if !damageAnimationPlays&&!attackAnimationPlays:
				walkAnimationPlays=true
		elif action==1:
			motionX+=ACCEL
			facingRight=true
			if !damageAnimationPlays&&!attackAnimationPlays:
				walkAnimationPlays=true
		elif isOnFloor:
			if action==2:
				motionY=-JUMPFORCE
				jumpAnimationPlays=true
	assert_eq(motionX,-45,"Moves left properly")
	assert_false(facingRight,"Isn't facing right")
	assert_true(walkAnimationPlays,"Walks")


func test_move_right_on_action_1():#in _move_direction()
	#simulated variables
	var action=1
	var motionX=0
	var motionY=0
	var isOnFloor=true
	var facingRight=false
	var standattackAnimationPlays=false
	var damageAnimationPlays=false
	var attackAnimationPlays=false
	var jumpAnimationPlays=false
	var walkAnimationPlays=false
	const JUMPFORCE=450
	const ACCEL=15
	
	for i in range(3):
		if action==0:
			motionX-=ACCEL
			facingRight=false
			if !damageAnimationPlays&&!attackAnimationPlays:
				walkAnimationPlays=true
		elif action==1:
			motionX+=ACCEL
			facingRight=true
			if !damageAnimationPlays&&!attackAnimationPlays:
				walkAnimationPlays=true
		elif isOnFloor:
			if action==2:
				motionY=-JUMPFORCE
				jumpAnimationPlays=true
	assert_eq(motionX,45,"Moves left properly")
	assert_true(facingRight,"Is facing right")
	assert_true(walkAnimationPlays,"Walks")

func test_jump_on_action_2():#in _move_direction()
	#simulated variables
	var action=2
	var motionX=0
	var motionY=0
	var isOnFloor=true
	var facingRight=false
	var standattackAnimationPlays=false
	var damageAnimationPlays=false
	var attackAnimationPlays=false
	var jumpAnimationPlays=false
	var walkAnimationPlays=false
	const JUMPFORCE=450
	const ACCEL=15
	
	if action==0:
		motionX-=ACCEL
		facingRight=false
		if !damageAnimationPlays&&!attackAnimationPlays:
			walkAnimationPlays=true
	elif action==1:
		motionX+=ACCEL
		facingRight=true
		if !damageAnimationPlays&&!attackAnimationPlays:
			walkAnimationPlays=true
	elif isOnFloor:
		if action==2:
			motionY=-JUMPFORCE
			jumpAnimationPlays=true
	assert_eq(motionX,0,"Moves left properly")
	assert_eq(motionY,-450,"Jump properly")
	assert_false(facingRight,"Isn't facing right")
	assert_true(jumpAnimationPlays,"Jumps")
	
func test_player_tracking():#in _on_moving_timeout()
	#simulated variables
	var action=3
	var playerXPosition=10
	var selfXPosition=50
	var player=playerXPosition
	
	if player>=selfXPosition:
		action=1
	elif player<selfXPosition:
		action=0
	assert_eq(action,0,"Performs proper movement")
	
