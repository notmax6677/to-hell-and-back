extends Node2D

# player body node
onready var player_body = get_node('../../../Player/Body')

func destroy():
	$Sprite.queue_free()
	$BlockBody.queue_free()
	
	$DestroyParticles.emitting = true
	$DestroyTimer.start()
	player_body.health = 0
	
	$DestroySound.play()


func _on_DestroyTimer_timeout():
	queue_free()
