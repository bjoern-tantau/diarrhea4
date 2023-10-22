extends ColorRect

signal restarting

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = get_viewport_rect().size
	size = rect

func _input(event):
	if event.is_action_pressed("ui_menu"):
		visible = !visible
		get_tree().paused = visible
		$VBoxContainer/Music.button_pressed = !AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
		$VBoxContainer/Sound.button_pressed = !AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound"))



func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_restart_pressed():
	restarting.emit()
	get_tree().reload_current_scene()
