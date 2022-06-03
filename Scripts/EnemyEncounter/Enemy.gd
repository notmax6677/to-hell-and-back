extends Node2D

# camera node
onready var camera = get_node('../../../..')

# player node
onready var player_body = get_node('../../../../../Player/Body')

# get max health
var max_health = 3

# set current health - default is 0
var health = 0

# alive variable
var alive = false

# random number generator
var rng = RandomNumberGenerator.new()

# colors (used for setting relative particle colors)
var colors = {
	alien_col = Color(0.87, 0.09, 0.91, 1),
	angel_col = Color(0.69, 0.53, 0.53, 1),
	demon_col = Color(1, 0, 0, 1),
}

# sign
onready var enemy_sign = get_node('../../../Sign')

# sign goto position
var sign_goto_pos = Vector2(120, 6)

# speed reducer for when sign is moving
var sign_speed_reducer = 8

func _ready():
	rng.randomize() # randomize seed
	$SpawnTimer.start(rng.randf_range(20, 60)) # set time left of timer randomly between 20 and 60

func _process(delta):
	# move sign towards goto
	enemy_sign.position += (sign_goto_pos - enemy_sign.position)/sign_speed_reducer
	
	# if health is half or less
	if health == 3:
		$Health/Health1.visible = false
		$Health/Health2.visible = false
		$Health/Health3.visible = true
	elif health == 2:
		$Health/Health1.visible = false
		$Health/Health2.visible = true
		$Health/Health3.visible = false
	elif health == 1:
		$Health/Health1.visible = true
		$Health/Health2.visible = false
		$Health/Health3.visible = false
	
	if player_body.dead == true:
		$Health/Health1.visible = false
		$Health/Health2.visible = false
		$Health/Health3.visible = false
		$Sprites.visible = false # make sprites group invisible
		$Particles.visible = false # invisible particles
		alive = false
		sign_goto_pos = Vector2(120, 6)
		$HurtTimer.stop()
		health = 0

# spawns the enemy
func spawn():
	# emit particles
	$OneShotParticles.emitting = true
	$OneShotParticles.one_shot = true
	# play spawn audio
	$Spawned.play()
	# start hurt timer
	$HurtTimer.start()
	
	# set position of sign
	sign_goto_pos = Vector2(-12, 6)
	# create random type out of possibilities
	var type = int(rng.randf_range(1, 3.9))
	
	# set visibility of sprites based on the type that was returned
	
	# alien
	if type == 1:
		$Sprites/Alien.visible = true
		$Sprites/Angel.visible = false
		$Sprites/Demon.visible = false
		$Particles.process_material.color = colors.alien_col
		$OneShotParticles.process_material.color = colors.alien_col
	# angel
	elif type == 2:
		$Sprites/Alien.visible = false
		$Sprites/Angel.visible = true
		$Sprites/Demon.visible = false
		$Particles.process_material.color = colors.angel_col
		$OneShotParticles.process_material.color = colors.angel_col
	# demon
	elif type == 3:
		$Sprites/Alien.visible = false
		$Sprites/Angel.visible = false
		$Sprites/Demon.visible = true
		$Particles.process_material.color = colors.demon_col
		$OneShotParticles.process_material.color = colors.demon_col
	
	alive = true
	visible = true
	$Sprites.visible = true # make sprite group visible
	$Particles.visible = true
	
	health = 3

# enemy is clicked on
func _on_HurtButton_button_down():
	if alive == true:
		health -= 1
		camera.shake()
		
		$Hit.play()
		
		# if died
		if health == 0:
			$Health/Health1.visible = false
			$Health/Health2.visible = false
			$Health/Health3.visible = false
			$Sprites.visible = false # make sprites group invisible
			$Particles.visible = false # invisible particles
			alive = false
			sign_goto_pos = Vector2(120, 6)
			$HurtTimer.stop()
			$SpawnTimer.start(rng.randf_range(10, 40)) # set time left of timer randomly between 10 and 40 (less time intervals after the first one)
			$Died.play()
			# emit particles
			$OneShotParticles.emitting = true
			$OneShotParticles.one_shot = true

# spawn timer timeout
func _on_SpawnTimer_timeout():
	if alive == false:
		spawn() # call spawn function

# every 5 seconds of being alive take away one heart from the player
func _on_HurtTimer_timeout():
	player_body.health -= 1
	camera.shake()
