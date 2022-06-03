extends Node2D


# for optimization, this script removes blocks that are no longer in play

# get player body
onready var player_body = get_node('../../Player/Body')


func _on_CleanTimer_timeout():
	
	# move to one chunk behind the player
	position.x = player_body.position.x - 192
	
	# get overlapping bodies
	var bodies = $Area.get_overlapping_bodies()
	
	# iterate thru bodies
	for i in range(bodies.size()):
		# get parent of individual body
		var parent = bodies[i].get_parent()
		
		# if the parent's name has the keyword "Block" in it, it means its a block
		if 'Block' in parent.name:
			parent.queue_free() # delete it cus it's not needed anymore
