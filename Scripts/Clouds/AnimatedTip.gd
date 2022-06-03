extends AnimatedSprite

# copied and modified from ground sprite script

# randomize the frame so all of the sprite pieces look more natural and less consistently synced

var rng = RandomNumberGenerator.new() # random number generator

func _ready():
	rng.randomize() # randomize seed
	
	flip_h = bool(int(rng.randf_range(0, 1))) # pick random horizontal flip
	
	frame = int(rng.randf_range(0, 7)) # pick random frame to begin at
	
	speed_scale = rng.randf_range(0.5, 1.5) # pick random float animation speed between 0.5 - 2
