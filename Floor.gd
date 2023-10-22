extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = get_viewport_rect()
	
	$CollisionShape2D.scale.x = rect.size.x / 64
	$CollisionShape2D.position.x = rect.size.x / 2
	
	var current_x = 0
	while current_x - 64 <= rect.size.x:
		var newground: Sprite2D = $Ground.duplicate()
		newground.position.x = current_x
		newground.position.y = $Ground.position.y
		add_child(newground)
		
		var current_y = $Underground.position.y
		while current_y - 64 <= rect.size.y:
			var newunderground: Sprite2D = $Underground.duplicate()
			newunderground.position.x = current_x
			newunderground.position.y = current_y
			add_child(newunderground)
			current_y += 64
		
		current_x += 64
