extends Node2D

@export_group("Spinners")
@export var timespin : Spinner
@export var hugspin : Spinner
@export var secondhugspin : Spinner
@export var thirdhugspin : Spinner 

var hug_active : bool =  true
var time : float = 0.0
var hugcount : int = 1 
func _ready() -> void:
	# EVERYTHING AFTER THE PRESSING START HAPPENS HERE
	
	# The flower bud is animating idle for a couple of seconds
	
	# The eyes of the character fade in, starts blinking
	
	# Cue emotional audio sting
	
	# The flower bud blossoms, including an orb of light that the player is meant to press spacebar on
	
	# Fade in spacebar animation
	
	# Turn on press spacebar boolean/set to true
	
	# After player presses spacebar, camera zooms into ball of light at an angle where characters eyes are visible
	
	# The ball of light fades in a grass field, with a version of the character third quarter, and the environment moving around them
	
	# FIRST LOGIC STEP 
	# Encounter another character post animation
	# Turn on press spacebar boolean/set to true 
	# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
	# Player presses and as they hold the spacebar 
	# Fade out instructions
	#- update spinners
		# Hugspin.value = -0.3(time)^2 + 9.8(time)
	# While space bar is pressed: 
		# Time += .1
	
	# signal connect for hugcountone
		# have the hugger fade away, then the world keeps moving on
		# fade the character so that they are older now
		# encounter another character 
		# turn on hug active
		# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
		# Player presses and as they hold the spacebar 
		# Fade out instructions
		# update spinners
	
	#signal connect for hugcounttwo
		# have the hugger fade away, then the world keeps moving on
		# fade the character so that they are older now
		# encounter another character 
		# turn on hug active
		# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
		# Player presses and as they hold the spacebar 
		# Fade out instructions
		# update spinners
	
	#signal connect for hugcountthree
		# have the hugger fade away, then the world keeps moving on
		# fade the character so that they are older now
		# encounter another character 
		# turn on hug active
		# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
		# Player presses and as they hold the spacebar 
		# Fade out instructions
		# update spinners
		
	# signal connect to endgame
		# fade out eyes at some point
		# zoom out of the light ball, no other visual assets there
		# fade in original light ball png
		# fade in character holding out hands
		# wait, then fade out the light ball
		# fade in the three rose buds, and have them play up to the score that they got?
		#[0 - 90] adjusted to the frame number
		# fade in the gravestones in her hand
		# have a tear roll down characters eye maybe
		# cut to end visual, which is character at the graveyard
			# score is calculated into one whole progress bar, while the other progress-
			# bars are set to 0 
			# Hold on and let go 
		
		
	pass

func _process(delta: float) -> void:
	timespin.value += 1
	if hug_active: 
		if hugcount == 1:
			if Input.is_action_pressed("Space"):
				time += delta
				hugspin.value = -0.3*time**2 + 9.8 * time
				print(hugspin.value)
			if Input.is_action_just_released("Space"):
				hug_active = false
				hugcount = 2
				# send a signal to tell the game to move forward?
