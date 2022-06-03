extends Node2D

# get player body node
onready var player_body = get_node('../Player/Body')

# get begin node
onready var begin = get_node('../Begin')

# colors
var heaven_col = Color(0.34, 0.11, 0.19, 1)
var hell_col = Color(0.15, 0.13, 0.3, 1)

# goto color
var goto_col = Color(0.34, 0.35, 0.38, 1) # default to start color

# current color
var current_col = Color(1, 1, 1, 1)

# color change reducer
var speed_reducer = 6

func _process(delta):
	# if game has began
	if begin.side != 'none' and player_body.moving_worlds == false:
		# if in heaven
		if player_body.ground_direction.y == -1:
			goto_col = heaven_col
		# if in hell
		elif player_body.ground_direction.y == 1:
			goto_col = hell_col
		
		# move towards goto color
		current_col.r += (goto_col.r - current_col.r)/speed_reducer
		current_col.g += (goto_col.g - current_col.g)/speed_reducer
		current_col.b += (goto_col.b - current_col.b)/speed_reducer
		
		# update background's color
		VisualServer.set_default_clear_color(current_col)
