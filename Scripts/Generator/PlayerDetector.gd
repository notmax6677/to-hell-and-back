extends Area2D

# chunk pixel amount = 192

# get player body node
onready var player_body = get_node('../../Player/Body')

# get parent node
onready var parent = get_node('..')

var moved = false

func _ready():
	position.x = player_body.position.x + 576 # set beginning position to 3 chunks in front of player

func _process(delta):
	position.y = player_body.position.y # update y position to always move in front of player by setting equal y pos

# every 0.2 seconds check if player has entered area and act accordingly (using timer child node)
func _on_MoveTimer_timeout():
	# get array of overlapping bodies
	var areas = get_overlapping_areas()
	
	# iterate through array
	for i in range(areas.size()):
		# if thresholdfinder area (area surrounding player sprite)
		if areas[i].name == 'ThresholdFinder' and moved == false:
			# create 5 chunk sector 2 chunks ahead (at the end of the current chunk)
			parent.create_sector(position.x/192 + 2)
			parent.clean()
			
			position.x += 960 # move forward 5 chunks (192 * 5 = 960)
