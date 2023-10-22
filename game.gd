extends Node2D

var height = 0
var ground_height = 0
var last_height = 0
var highscore = 0

var highscore_filename = "user://highscore.txt"
var settings_filename = "user://settings.json"

var Item = preload("res://item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
#	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	ground_height = $Player.position.y
	$HUD.custom_viewport = $Player.camera
	load_highscore()
	load_settings()
	
func load_highscore():
	var file = FileAccess.open(highscore_filename, FileAccess.READ)
	if file != null:
		highscore = file.get_32()

func save_highscore():
	var file = FileAccess.open(highscore_filename, FileAccess.WRITE)
	file.store_32(highscore)

func load_settings():
	var file = FileAccess.open(settings_filename, FileAccess.READ)
	if file != null:
		var settings = file.get_var()
		if settings != null:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), settings.mute_music)
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), settings.mute_sound)

func save_settings():
	var file = FileAccess.open(settings_filename, FileAccess.WRITE)
	var settings = {
		"mute_music": AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")),
		"mute_sound": AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound")),
	}
	file.store_var(settings)

func _process(_delta):
	if $Player.position.y > ground_height:
		ground_height = $Player.position.y
		
	height = ground_height - $Player.position.y
	
	if height > highscore:
		highscore = height
	
	$HUD/Highscore.text = str(floor(highscore / 50)) + " m"
	$HUD/Height.text = str(floor(height / 50)) + " m"
	$HUD/Fuel.text = str(snapped($Player.fuel, 0.1)) + " l"
	
	spawn_item()

func spawn_item():
	var view_height = get_viewport_rect().size.y
	var view_width = get_viewport_rect().size.x
	
	if height > last_height + view_height:
		var item = Item.instantiate()
		item.position.x = randf_range(0, view_width)
		item.position.y = randf_range($Player.position.y - view_height, $Player.position.y - view_height * 2)
		item.pick_up.connect(_on_item_pick_up)
		add_child(item)
		last_height = last_height + view_height

func _on_item_pick_up(fuel_amount: float):
	$Player.fuel += fuel_amount

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_highscore()
		save_settings()
		get_tree().quit()
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT || what == NOTIFICATION_WM_WINDOW_FOCUS_OUT || what == NOTIFICATION_APPLICATION_PAUSED:
		get_tree().paused = true
		$Music.stop()
		$HUD/Menu.visible = true
	if what == NOTIFICATION_APPLICATION_FOCUS_IN || what == NOTIFICATION_WM_WINDOW_FOCUS_IN || what == NOTIFICATION_APPLICATION_RESUMED:
		$Music.play()


func _on_music_toggled(button_pressed):
	AudioServer.set_bus_mute(1, !button_pressed)


func _on_sound_toggled(button_pressed):
	AudioServer.set_bus_mute(2, !button_pressed)


func _on_menu_restarting():
	save_highscore()
	save_settings()
