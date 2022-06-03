extends AnimatedSprite

# randomize the frame so all of the fabric pieces look more natural and less consistently synced

var rng = RandomNumberGenerator.new() # random number generator

func _ready():
	rng.randomize() # randomize seed
	frame = int(rng.randf_range(0, 5)) # set frame to random 0 - 5
