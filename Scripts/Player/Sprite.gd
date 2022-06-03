extends AnimatedSprite

onready var body = get_node('..')

var rng = RandomNumberGenerator.new()

var state = 'run' # state can either be:
	# 1) run
	# 2) air
	# 3) world_switch
	# 4) dead

func _process(delta):
	if body.dead == false:
		if body.moving_worlds == true:
			state = 'world_switch'
			modulate.a = 0.4 # opacity 40%
		elif body.is_on_floor() == true:
			state = 'run'
			modulate.a = 1 # opacity 100%
		else:
			state = 'air'
			modulate.a = 1 # opacity 100%
		
		# set opacity to 40% while invincible
		if body.invincible == true:
			modulate.r = rng.randf_range(0, 1)
			modulate.g = rng.randf_range(0, 1)
			modulate.b = rng.randf_range(0, 1)
		else:
			modulate.r = 1
			modulate.g = 1
			modulate.b = 1
	else:
		# dead state
		state = 'dead'
		# set everything to default colors and alpha
		modulate.a = 1
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
	
	# set animation according to state
	play(state)
