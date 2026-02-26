extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://main.tscn")
	if event.is_action_pressed("fullscreen"):
		var window = get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN
