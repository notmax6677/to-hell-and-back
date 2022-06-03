extends Node2D

# player body node
onready var player_body = get_node('../../../Player/Body')

# destroying
var destroying = false

# on creation
func _process(delta):
	if destroying == false:
		# get overlapping bodies
		var bodies = $Area.get_overlapping_bodies()
		
		# default is false
		var destroy = false
		
		# iterate thru
		for i in range(bodies.size()):
			
			if bodies[i].get_parent().name == 'Player' and player_body.dead == false:
				player_body.start_switch_worlds()
				$UseAudio.play()
			
			destroy = true
		
		# if destroy = true
		if destroy == true:
			destroy_self()

func destroy_self():
	$Sprite.queue_free()
	$Area.queue_free()
	$DeleteTimer.start()
	$Particles.emitting = true # shoot particles
	destroying = true


func _on_DeleteTimer_timeout():
	queue_free()
