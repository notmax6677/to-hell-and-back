extends Camera2D

# this script also manages the clouds

# get player nodes
onready var player = get_node('../Player')
onready var player_body = get_node('../Player/Body')

# get clouds
onready var heaven_clouds = $HeavenClouds

onready var hell_clouds = $HellClouds

# cloud positions
var heaven_cl_goto = Vector2.ZERO
var hell_cl_goto = Vector2.ZERO

# speed reducers
var cam_speed_reducer = 4
var cloud_speed_reducer = 4

# shake
var shake = false

# random number generator (for shaking)
var rng = RandomNumberGenerator.new()

# beginning
onready var begin = get_node('../Begin')

func _process(delta):
	# move to player
	position += (Vector2(player_body.position.x + 120, player_body.position.y) - position)/cam_speed_reducer
	
	if begin.side != 'none':
		# set ui to visible
		$UI.visible = true
		
		# small effect to change rotation based on player's distance from ground
		rotation_degrees = player_body.height_from_floor/30
		
		# set cloud goto positions based on current dimension/world
		if player.current_world == 'heaven':
			heaven_cl_goto.y = -12
			hell_cl_goto.y = -20
		elif player.current_world == 'hell':
			heaven_cl_goto.y = 20
			hell_cl_goto.y = 12
		
		# offset the camera slightly if shake is true
		if shake == true:
			offset = Vector2(0, rng.randf_range(-2, 2))
		
		# move clouds to their goto positions
		heaven_clouds.position += (heaven_cl_goto - heaven_clouds.position)/cloud_speed_reducer
		hell_clouds.position += (hell_cl_goto - hell_clouds.position)/cloud_speed_reducer
	else:
		# move clouds to their goto positions
		heaven_clouds.position += (heaven_cl_goto - heaven_clouds.position)/cloud_speed_reducer
		hell_clouds.position += (hell_cl_goto - hell_clouds.position)/cloud_speed_reducer

# begin shake
func shake():
	shake = true
	$ShakeTimer.start()

# cancel shake
func _on_ShakeTimer_timeout():
	shake = false
