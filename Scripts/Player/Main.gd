extends Node2D

# current world
var current_world = 'heaven'

func _ready():
	
	# set child object beginning positions
	
	$Body.position.x = -60
	$Body.position.y = 0 # set body position
	
	$HellThreshold.position.y = -60 # set hell threshold position
	
	$HeavenThreshold.position.y = 60 # set heaven threshold position
