class_name UI
extends Control

@onready var music := %Music as Music
@onready var time_left = $Time
@onready var lives := $Lives as HBoxContainer
@onready var ff := $FF

const LOST_LIFE = preload("res://ui/VIDA-VAZIA.png")
const LIFE = preload("res://ui/VIDA-CHEIA.png")

func _ready() -> void:
	ff.hide()

func _process(_delta: float) -> void:
	time_left.value = music.song_progress

func update_lives(life_count: int):
	var i = 1
	for life in lives.get_children():
		(life as TextureRect).texture = LOST_LIFE if life_count < i else LIFE
		i += 1

func _on_music_hospital_cutscene(_number) -> void:
	ff.show()

func _on_ff_pressed() -> void:
	ff.hide()
	music.speed_up_cutscene()

func _on_music_transition_to_game() -> void:
	ff.hide()
