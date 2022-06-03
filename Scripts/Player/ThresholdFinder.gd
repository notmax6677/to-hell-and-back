extends Area2D

# get other needed nodes

onready var body = get_node('..')

onready var parent = get_node('../..')

# if entered
func _on_HeavenThreshold_area_entered(area):
	# and moving thru world but not current world (see based on gravity cus diff worlds have diff gravity)
	if body.moving_worlds and body.ground_direction.y == -1 and area.name == 'ThresholdFinder':
		body.end_switch_worlds()
		
		# set current world in root
		parent.current_world = 'hell'


# if entered
func _on_HellThreshold_area_entered(area):
	# and moving thru world but not current world (see based on gravity cus diff worlds have diff gravity)
	if body.moving_worlds and body.ground_direction.y == 1 and area.name == 'ThresholdFinder':
		body.end_switch_worlds()
		
		# set current world in root
		parent.current_world = 'heaven'
