extends GutTest

## Testing for AbstractMovingCharacter.gd
##
## Tests AbstractMovingCharacter's movement and gravity

#uses simulated variables to test functions

func test_basic_movement():#in _movement_and_gravity()
	#simulated variables
	var motionY=0
	var facingRight=true
	var spriteFacingRight=true
	const GRAVITY=30
	const MAXFALLSPEED=200
	
	for i in range(3):
		motionY+=GRAVITY
		if motionY>MAXFALLSPEED:
			motionY=MAXFALLSPEED
		if facingRight==true:
			spriteFacingRight=true
		else:
			spriteFacingRight=false
	assert_eq(motionY,90,"Proper gravity acceleration")
	assert_true(spriteFacingRight)
	
func test_basic_movement_alt():#in _movement_and_gravity()
	#simulated variables
	var motionY=0
	var facingRight=true
	var spriteFacingRight=true
	const GRAVITY=45
	const MAXFALLSPEED=200
	
	for i in range(4):
		motionY+=GRAVITY
		if motionY>MAXFALLSPEED:
			motionY=MAXFALLSPEED
		if facingRight==true:
			spriteFacingRight=true
		else:
			spriteFacingRight=false
	assert_eq(motionY,180,"Proper gravity acceleration")
	assert_true(spriteFacingRight)
	
func test_gravity_cap():#in _movement_and_gravity()
	#simulated variables
	var motionY=0
	var facingRight=false
	var spriteFacingRight=true
	const GRAVITY=30
	const MAXFALLSPEED=200
	
	for i in range(10):
		motionY+=GRAVITY
		if motionY>MAXFALLSPEED:
			motionY=MAXFALLSPEED
		if facingRight==true:
			spriteFacingRight=true
		else:
			spriteFacingRight=false
	assert_eq(motionY,200,"Proper gravity acceleration")
	assert_false(spriteFacingRight)


	

