extends Area2D

# get body node
onready var body = get_node('../Body')

# keep up with body's x position
func _process(delta):
	position.x = body.position.x
