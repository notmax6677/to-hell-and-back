extends Node2D

# initiates the destruction of the block, must have DestroyParticles and DestroyTimer child nodes
func destroy():
	# destroy no longer necessary
	if 'HellBlock' in name:
		$TipSprite.queue_free()
	$BlockSprite.queue_free()
	$BlockBody.queue_free()
	
	# play destruction particles
	$DestroyParticles.emitting = true
	
	# play destruction timer
	$DestroyTimer.start()
	
	# play destroy audio
	$DestroySound.play()

# destroy self on DestroyTimer timeout
func _on_DestroyTimer_timeout():
	queue_free()
