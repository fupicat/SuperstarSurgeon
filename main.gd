extends Node2D

@onready var music := %Music as Music
@onready var anim := $AnimationPlayer as AnimationPlayer
@onready var hospital_anim := $Background/MusicSections as AnimationPlayer

var good_outcome := false
var good_outcome_total = 0

func _ready() -> void:
	music.transition_to_game.connect(func ():
		good_outcome = false
		anim.play("to_game")
		)
	music.transition_to_hospital.connect(func (): anim.play("to_hospital"))
	music.hospital_cutscene.connect(func (number):
		if good_outcome:
			good_outcome_total += 1
			hospital_anim.play("%s_good" % (number + 1))
		else:
			hospital_anim.play("%s_bad" % (number + 1))
		)
	music.end.connect(func():
		anim.play("fade_out")
		await anim.animation_finished
		if (good_outcome_total == 0):
			get_tree().change_scene_to_file("res://endings/bad_ending.tscn")
		elif (good_outcome_total == 4):
			get_tree().change_scene_to_file("res://endings/good_ending.tscn")
		else:
			get_tree().change_scene_to_file("res://endings/meh_ending.tscn")
		)
