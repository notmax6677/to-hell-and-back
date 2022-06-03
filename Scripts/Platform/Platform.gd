extends Node2D

# preload block types
const hv_block = preload('res://Scenes/Game/Objects/HeavenBlock.tscn')
const hl_block = preload('res://Scenes/Game/Objects/HellBlock.tscn')

# random number generator
var rng = RandomNumberGenerator.new()

# length that will later be determined
var length = 0


func _ready():
	# randomize seed
	rng.randomize()
	
	# create random length
	length = int(rng.randf_range(2, 6.9))

# create a random length platform between 2-6 blocks
# type can either be hell or heaven
func create(type):
	# check type
	if type == 'hell':
		# iterate thru length
		for i in range(length):
			# create local instance
			var local_instance = hl_block.instance()
			
			local_instance.name = 'HellBlock' + str(get_children().size()) # set unique name for local instance
			
			local_instance.position.x = i*12 # set its x position according to i index
			
			add_child(local_instance) # add instance to tree
		
	elif type == 'heaven':
		# iterate thru length
		for i in range(length):
			# create local instance
			var local_instance = hv_block.instance()
			
			local_instance.name = 'HeavenBlock' + str(get_children().size()) # set unique name for local instance
			
			local_instance.position.x = i*12 # set its x position according to i index
			
			add_child(local_instance) # add instance to tree
	
	var children = get_children()
	
	for i in range(children.size()):
		pass#children[i].BlockClean()
