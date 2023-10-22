extends Area2D

signal pick_up(fuel_amount: float)

var rotation_direction = 1
@export var rotation_speed = 100
@export var fuel_amount: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomise()

func randomise():
	var sprites = []
	for sprite in get_children():
		if sprite is Sprite2D:
			sprite.visible = false
			sprites.append(sprite)
	
	sprites.pick_random().visible = true

func _process(delta):
	if rotation_degrees > 30:
		rotation_direction = -1
	
	if rotation_degrees < -30:
		rotation_direction = 1
	
	rotation_degrees += rotation_direction * delta * rotation_speed



func _on_body_entered(_body):
	hide()
	pick_up.emit(fuel_amount)
	
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	queue_free()
