extends PathFollow2D

# speed of following path
var speed = 100

func _process(delta):
	offset += speed * delta
