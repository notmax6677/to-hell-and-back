extends Node2D


onready var player_body = get_node('../../../Player/Body')

var score = 0

var goto_col = Color(1, 1, 1, 1)

var current_col = Color(1, 1, 1, 1)

var speed_reducer = 6

func _process(delta):
	# score is amount player has moved, divided by 1000000 whatever that number is LMAO
	score = player_body.position.x/1000000
	
	# heaven
	if player_body.ground_direction.y == -1:
		goto_col = Color(1, 1, 1, 1)
	# hell
	elif player_body.ground_direction.y == 1:
		goto_col = Color(0, 0, 0, 0)
	
	# move current color to goto color
	current_col.r += (goto_col.r - current_col.r)/speed_reducer
	current_col.g += (goto_col.g - current_col.g)/speed_reducer
	current_col.b += (goto_col.b - current_col.b)/speed_reducer
	
	modulate = current_col
	
	# set text to score
	$Count.text = str(score)
