extends CharacterBody2D

@export var rotation_speed = 10 # How fast the player will move (pixels/sec).
@export var shit_force = 2000
@export var friction = 250
@export var max_velocity = 1000
@export var camera: Camera2D

@export var fuel = 10
@export var fuel_consumption = 0.3

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var screen_size # Size of the game window.

var max_pitch = 1.5
var min_pitch = 0.9
var pitch_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera2D
	screen_size = get_viewport_rect().size
	camera.limit_right = screen_size.x
	camera.limit_bottom = screen_size.y
	position.x = screen_size.x / 2
	$AnimationPlayer.play("idle")

func _process(delta):
	if Input.is_action_pressed("left"):
		rotation -= rotation_speed * delta
	
	if Input.is_action_pressed("right"):
		rotation += rotation_speed * delta

func _physics_process(delta):
	$Diarrhea.emitting = false
	velocity.y += gravity * delta
	
	if is_zero_approx(velocity.x):
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= friction * delta
	elif velocity.x < 0:
		velocity.x += friction * delta
		
	if fuel <= 0:
		fuel = 0
	
	if Input.is_action_pressed("click"):
#		look_at(get_global_mouse_position())
		rotation = get_global_mouse_position().angle_to_point(position) - 0.5 * PI
		
	if Input.is_action_pressed("shit") && fuel > 0:
		fuel -= delta * fuel_consumption
		var shit_velocity = Vector2(0, -shit_force * delta).rotated(rotation)
		velocity += shit_velocity
		$Diarrhea.emitting = true
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
			
		if $AudioStreamPlayer.pitch_scale > max_pitch:
			pitch_direction = -1
			max_pitch = randf_range(1.1, 1.7)
		
		if $AudioStreamPlayer.pitch_scale < min_pitch:
			pitch_direction = 1
			min_pitch = randf_range(0.8, 1.1)
			
		$AudioStreamPlayer.pitch_scale += 0.1 * pitch_direction * delta
		
		if velocity.length() >= max_velocity:
			$AnimationPlayer.play("super_shit")
		else:
			$AnimationPlayer.play("shit")
	elif velocity.y > 300 && !is_on_floor():
		$AnimationPlayer.play("falling")
		$AudioStreamPlayer.stop()
	else:
		$AnimationPlayer.play("idle")
		$AudioStreamPlayer.stop()
	
	velocity = velocity.limit_length(max_velocity)
	move_and_slide()
	
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
