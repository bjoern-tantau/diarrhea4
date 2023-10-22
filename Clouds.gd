extends ParallaxLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = get_viewport_rect()
	motion_mirroring.x = rect.size.x
	motion_mirroring.y = rect.size.y
	
	for child in get_children():
		child.position.x = randf_range(0, rect.size.x)
		child.position.y = randf_range(0, rect.size.y)
		var scale_child = randf_range(0.1, 1)
		child.scale.x = scale_child
		child.scale.y = scale_child

