extends Node2D

# side
var side = 'none'

# player
onready var player_body = get_node('../Player/Body')

# player sprite
onready var player_sprite = get_node('../Player/Body/Sprite')

# camera
onready var cam = get_node('../Camera')

# begin sign
onready var begin_sign = get_node('../Camera/BeginSign')

# enemy
onready var enemy_timer = get_node('../Camera/EnemyEncounter/EnemyPath/PathFollower/Enemy/SpawnTimer')

# enemy (needed to get random number generator for its spawn timer)
onready var enemy = get_node('../Camera/EnemyEncounter/EnemyPath/PathFollower/Enemy')

# game music node
onready var music = get_node('../GameMusic')

func _ready():
	music.pitch_scale = 0.5

func _on_Bot_input_event(viewport, event, shape_idx):
	if event.button_mask == 1 and side == 'none':
		bot()
	# move clouds (heaven bottom hell top)
	cam.heaven_cl_goto.y = 20
	cam.hell_cl_goto.y = 12



func _on_Top_input_event(viewport, event, shape_idx):
	if event.button_mask == 1 and side == 'none':
		top()
	# move clouds (heaven top hell bottom)
	cam.heaven_cl_goto.y = -12
	cam.hell_cl_goto.y = -20


func top():
	side = 'top'
	player_body.end_switch_worlds()
	player_body.start_switch_worlds()
	begin_sign.visible = false
	player_sprite.visible = true
	cam.shake()
	$Started.play()
	enemy_timer.start(enemy.rng.randf_range(20, 60)) # set time left of timer randomly between 20 and 60
	music.pitch_scale = 1

func bot():
	side = 'bot'
	player_body.start_switch_worlds()
	begin_sign.visible = false
	player_sprite.visible = true
	cam.shake()
	$Started.play()
	enemy_timer.start(enemy.rng.randf_range(20, 60)) # set time left of timer randomly between 20 and 60
	music.pitch_scale = 1
