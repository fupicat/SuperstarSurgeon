extends Control

const INSTRUCTIONS_NORMAL = preload("res://menu/instructions.png")
const INSTRUCTIONS_HOVER = preload("res://menu/instructions_hover.png")
@onready var instructions = $Main/Instructions
const PLAY_NORMAL = preload("res://menu/play.png")
const PLAY_HOVER = preload("res://menu/play_hover.png")
@onready var play = $Main/Play
const RETURN_HOVER = preload("res://menu/BOTÃO-RETORNAR-SELECIONADO.png")
@onready var returnb = $Instructions/Return
@onready var butt_sound = $Button
@onready var anim = $AnimationPlayer

func _ready() -> void:
	$Main/Instructions/Button.mouse_entered.connect(func(): instructions.texture = INSTRUCTIONS_HOVER)
	$Main/Instructions/Button.mouse_exited.connect(func(): instructions.texture = INSTRUCTIONS_NORMAL)
	$Main/Instructions/Button.pressed.connect(func():
		instructions.texture = INSTRUCTIONS_NORMAL
		butt_sound.play()
		$Main.hide()
		$Instructions.show()
	)
	$Main/Play/Button.mouse_entered.connect(func(): play.texture = PLAY_HOVER)
	$Main/Play/Button.mouse_exited.connect(func(): play.texture = PLAY_NORMAL)
	$Main/Play/Button.pressed.connect(func():
		butt_sound.play()
		anim.play("fadeout")
		await anim.animation_finished
		get_tree().change_scene_to_file("res://main.tscn")
	)
	$Instructions/Return/Button.mouse_entered.connect(func(): returnb.texture = RETURN_HOVER)
	$Instructions/Return/Button.mouse_exited.connect(func(): returnb.texture = null)
	$Instructions/Return/Button.pressed.connect(func():
		butt_sound.play()
		returnb.texture = null
		$Main.show()
		$Instructions.hide()
	)
