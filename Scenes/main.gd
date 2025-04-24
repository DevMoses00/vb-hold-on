extends Node2D

@export_group("Spinners")
@export var timespin : Spinner
@export var hugspin : Spinner
@export var secondhugspin : Spinner
@export var thirdhugspin : Spinner 
@export var totalspin : Spinner

@export_group("Assets")
@export var eyes : AnimatedSprite2D
@export var orb : AnimatedSprite2D
@export var foreground : AnimatedSprite2D
@export var flower : AnimatedSprite2D
@export var hug : AnimatedSprite2D
@export var holdon: Sprite2D
@export var space : AnimatedSprite2D
@export var whitecircle : Sprite2D
@export var handcover : Sprite2D
@export_group("Flowers")
@export var fh1 : AnimatedSprite2D
@export var fh2 : AnimatedSprite2D
@export var fh3 : AnimatedSprite2D
@export_group("Coffins")
@export var coffin1 : Sprite2D
@export var coffin2 : Sprite2D
@export var coffin3 : Sprite2D

var hug_active : bool =  true
var time : float = 0.0
var hugcount : int = 0 
var spinnervar

# BOOLS
var orbSelect : bool = false
var hugplayed : bool = false
var endgame : bool = false
# SIGNALS
signal first_logic_signaled
signal hugging_signaled
signal hug_count_one
signal hug_count_two
signal hug_count_three

func _ready() -> void:
	# EVERYTHING AFTER THE PRESSING START HAPPENS HERE
	await get_tree().create_timer(2).timeout
	fade_tween_in($Logo)
	await get_tree().create_timer(4).timeout
	fade_tween_out($Logo)
	await get_tree().create_timer(2).timeout
	# Foreground edge comes into view
	main_size(foreground)
	# The flower bud is animating idle for a couple of seconds
	await get_tree().create_timer(5).timeout
	# The eyes of the character fade in, starts blinking
	fade_tween_in(eyes)
	await get_tree().create_timer(3).timeout
	# Cue emotional audio sting
	# SoundManager.playmfx()
	# The flower bud blossoms
	
	flower.play()
	await get_tree().create_timer(2).timeout
	# Including an orb of light that the player is meant to press spacebar on, Fade in spacebar animation
	orb_rise(orb) 

	# The ball of light fades in a grass field, with a version of the character third quarter, and the environment moving around them
	
	# FIRST LOGIC STEP 
	hugging_signaled.connect(huglogic)
	
	# signal connect for hugcountone
	hug_count_one.connect(hugcountone)
	hug_count_two.connect(hugcounttwo)
	hug_count_three.connect(hugcountthree)
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
		
		
	pass

func _process(delta: float) -> void:
	if timespin.value >= timespin.max_value:
		hug_count_three.emit()
	if hug_active == true: 
		if hugcount == 1:
			if Input.is_action_pressed("Space"):
				huglogic()
				time += delta
				hugspin.value = -0.3*time**2 + 9.8 * time
				print(hugspin.value)
			if Input.is_action_just_released("Space"):
				hug.play_backwards()
				hug_active = false
				hug_count_one.emit()
		if hugcount == 2:
			if Input.is_action_pressed("Space"):
				huglogic()
				print("working")
				time += delta
				# different equation
				secondhugspin.value = 10 * cos((2*PI*time)/5)
				print(secondhugspin.value)
			if Input.is_action_just_released("Space"):
				hug.play_backwards()
				hug_active = false
				hug_count_two.emit()
				# send a signal to tell the game to move forward?
		if hugcount == 3:
			if Input.is_action_pressed("Space"):
				huglogic()
				time += delta
				# different equation
				thirdhugspin.value = 0.5*time**2 + (-1.8 * time) + 1.8
				print(thirdhugspin.value)
			if Input.is_action_just_released("Space"):
				hug.play_backwards()
				hug_active = false
				hugcount = 4
				hug_count_three.emit()
	if endgame == true: 
		if Input.is_action_pressed("Space"):
				# different equation
				totalspin.value += 2
				if totalspin.value >= totalspin.max_value:
					get_tree().reload_current_scene()
func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)

func main_size(image) -> void:
	var sizeTween = get_tree().create_tween()
	sizeTween.tween_property(image, "scale", Vector2(1,1),2).set_ease(Tween.EASE_OUT_IN)
	sizeTween.tween_property(image, "scale", Vector2(1.01,1.02),.3).set_ease(Tween.EASE_OUT_IN)
func orb_rise(image) -> void:
	fade_tween_in(orb)
	var tween = get_tree().create_tween()
	tween.tween_property(image, "position:y", -20, 3)
	tween.tween_interval(3)
	tween.tween_callback(orbSelectTrue)
func orbSelectTrue():
	# fade in the spacebar UI
	fade_tween_in($Space2)
	await get_tree().create_timer(1).timeout
	#space.play("Press")
	orbSelect = true

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("Space") and orbSelect == true:
			var orbTween = get_tree().create_tween()
			orbTween.tween_callback(fade_tween_out.bind($Space2))
			orbTween.tween_callback(fade_tween_out.bind(flower))
			orbTween.parallel().tween_property(eyes, "scale", Vector2(1.1,1.1),3)
			orbTween.parallel().tween_property(orb, "scale", Vector2(3,3),3)
			orbTween.parallel().tween_property(orb, "position", Vector2(700, 1300),3)
			orbTween.finished.connect(firstLogicStep)
			orbSelect = false

func firstLogicStep():
	# Encounter another character post animation
	fade_tween_in(hug)
	hug.play("hug_trans_1")
	$Timer.start()
	await get_tree().create_timer(4).timeout
	fade_tween_in(holdon)
	spinnervar = hugspin
	spinnerhover()
	await get_tree().create_timer(3).timeout
	# Turn on press spacebar boolean/set to true 
	# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
	fade_tween_in(space)
	hug_active = true
	hugcount = 1

func huglogic():
	if hugplayed == false:
		if hugcount == 1:
			hug.play("hug_1")
		if hugcount == 2:
			hug.play("hug_2")
		if hugcount == 3:
			hug.play("hug_3")
		fade_tween_out(holdon)
		fade_tween_out(space)
		hugplayed = true

func _on_timer_timeout() -> void:
	timespin.value += 1

func hugcountone():
	# have the hugger fade away, then the world keeps moving on
	await get_tree().create_timer(2).timeout
	spinnerback()
	fade_tween_out(hug)
	# fade the character so that they are older now
	await get_tree().create_timer(5).timeout
	# encounter another character 
	fade_tween_in(hug)
	hug.play("hug_trans_2")
	await get_tree().create_timer(4).timeout
	fade_tween_in(holdon)
	spinnervar = secondhugspin
	spinnerhover()
	await get_tree().create_timer(3).timeout
	# Turn on press spacebar boolean/set to true 
	# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
	fade_tween_in(space)
	hug_active = true
	hugplayed = false
	time = 0
	hugcount = 2
	print("hug2_ready")


func hugcounttwo():
	# have the hugger fade away, then the world keeps moving on
	await get_tree().create_timer(2).timeout
	spinnerback()
	fade_tween_out(hug)
	# fade the character so that they are older now
	await get_tree().create_timer(5).timeout
	# encounter another character 
	fade_tween_in(hug)
	hug.play("hug_trans_3")
	await get_tree().create_timer(4).timeout
	fade_tween_in(holdon)
	spinnervar = thirdhugspin
	spinnerhover()
	await get_tree().create_timer(3).timeout
	# Turn on press spacebar boolean/set to true 
	# Fade in PNG 'HOLD ON' and fade in spacebar holding instruction
	fade_tween_in(space)
	hug_active = true
	hugplayed = false
	time = 0
	hugcount = 3
	print("hug3_ready")

func hugcountthree():
	# signal connect to endgame
	await get_tree().create_timer(2).timeout
	$Timer.stop()
	fade_tween_out(space)
	fade_tween_out(holdon)
	spinnerback()
	fade_tween_out(hug)
	# fade out eyes at some point
	fade_tween_out(eyes)
	await get_tree().create_timer(5).timeout
		# zoom out of the light ball, no other visual assets there
		# fade in original light ball png
	var tween = get_tree().create_tween()
	tween.tween_property(orb, "scale",Vector2(0.3,0.3),3)
	tween.parallel().tween_property(orb,"position", Vector2(2,81),3)
	await get_tree().create_timer(4).timeout
		# wait, then fade out the light ball
	fade_tween_out(orb)
		# fade in character holding out hands
	fade_tween_in(whitecircle)
	await get_tree().create_timer(4).timeout
	fade_tween_in(handcover)
		# fade in the three rose buds, and have them play up to the score that they got?
	await get_tree().create_timer(5).timeout
	fade_tween_in(fh1)
	await get_tree().create_timer(1).timeout
	fade_tween_in(fh2)
	await get_tree().create_timer(1).timeout
	fade_tween_in(fh3)
	await get_tree().create_timer(3).timeout
	fh1.play()
	fh2.play()
	fh3.play()
		#[0 - 90] adjusted to the frame number
	await get_tree().create_timer(5).timeout
	# fade in the gravestones in her hand
	fade_tween_out(fh1)
	fade_tween_in(coffin1)
	await get_tree().create_timer(1).timeout
	fade_tween_out(fh2)
	fade_tween_in(coffin2)
	await get_tree().create_timer(1).timeout
	fade_tween_out(fh3)
	fade_tween_in(coffin3)
	await get_tree().create_timer(7).timeout
		# have a tear roll down characters eye maybe
	fade_tween_out(handcover)
	fade_tween_out(whitecircle)
	fade_tween_out(coffin1)
	fade_tween_out(coffin2)
	fade_tween_out(coffin3)
	fade_tween_out(timespin)
	fade_tween_in($Closing)
	# turn off a bunch of different visuals to hard cut to the grave yard
		# cut to end visual, which is character at the graveyard
	await get_tree().create_timer(4).timeout
	var tweenhug = get_tree().create_tween()
	tweenhug.tween_property(hugspin,"position", Vector2(46,-160),2)
	tweenhug.parallel().tween_property(secondhugspin,"position", Vector2(400,-365),2)
	tweenhug.parallel().tween_property(thirdhugspin,"position", Vector2(590,-10),2)
	await get_tree().create_timer(4).timeout
	timercount()
	# score is calculated into one whole progress bar, while the other progress-
			# bars are set to 0 
			# Hold on and let go 

func spinnerhover():
	var tween = get_tree().create_tween()
	tween.tween_property(spinnervar,"position", Vector2(270,-320),2)

func spinnerback():
	var tween = get_tree().create_tween()
	if spinnervar == hugspin:
		tween.tween_property(spinnervar,"position", Vector2(760,-500),2)
	elif spinnervar == secondhugspin:
		tween.tween_property(spinnervar,"position", Vector2(590,-500),2)
	elif spinnervar == thirdhugspin:
		tween.tween_property(spinnervar,"position", Vector2(420,-500),2)

func timercount():
	var totalhug = hugspin.value + secondhugspin.value + thirdhugspin.value
	print(totalspin.value)
	var hug1 = int(hugspin.value)
	var hug2 = int(secondhugspin.value)
	var hug3 = int(thirdhugspin.value)
	
	for x in hug1 + 1:
		hugspin.value -= 1
		await get_tree().create_timer(.01).timeout
	for x in hug2 + 1:
		secondhugspin.value -= 1
		await get_tree().create_timer(.01).timeout
	for x in hug3 + 1:
		thirdhugspin.value -= 1
		await get_tree().create_timer(.01).timeout
	for x in totalhug:
		totalspin.value += 1
		await get_tree().create_timer(.01).timeout
	
	await get_tree().create_timer(3).timeout
	fade_tween_out($Closing)
	fade_tween_in($End)
	var tween = get_tree().create_tween()
	tween.tween_property(totalspin, "position", Vector2(280,-500),1.5)
	await get_tree().create_timer(3).timeout
	fade_tween_in($phrase)
	await get_tree().create_timer(2).timeout
	for x in totalhug:
		totalspin.value -= 1
		await get_tree().create_timer(.01).timeout
	await get_tree().create_timer(2).timeout
	endgame = true
	fade_tween_in($spaceend)
	
	
	
