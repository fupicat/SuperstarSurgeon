extends Control

func _ready() -> void:
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.finished.connect(func():
		$AudioStreamPlayer.play()
	)

func back_to_menu(_anim_name):
	get_tree().change_scene_to_file("res://menu/menu.tscn")
