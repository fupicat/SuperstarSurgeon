class_name Shootable
extends RigidBody2D

@export var max_left = -60
@export var max_right = 1200
@export var max_up = -60
@export var max_down = 690
@export var good = false

var music: Music
var game: Game
var main: Node2D
var anim: AnimationPlayer
var audio: AudioStreamPlayer
var with_devil = false

const GOOD_APPEAR = preload("res://balls/good_appear.tscn")
const GOOD_COLLECT = preload("res://balls/good_collect.tscn")
const BAD_APPEAR = preload("res://balls/bad_appear.tscn")
const DEVIL_DIE = preload("res://balls/devil_die.tscn")

func _ready() -> void:
	var smoke = GOOD_APPEAR.instantiate() if good else BAD_APPEAR.instantiate()
	smoke.global_position = global_position
	game.add_child(smoke)
	music.transition_to_hospital.connect(func():
		var smoke2 = GOOD_APPEAR.instantiate() if good else BAD_APPEAR.instantiate()
		smoke2.global_position = global_position
		game.add_child(smoke2)
		queue_free()
		)
	music.speeding_up.connect(func():
		var smoke2 = GOOD_APPEAR.instantiate() if good else BAD_APPEAR.instantiate()
		smoke2.global_position = global_position
		game.add_child(smoke2)
		queue_free()
		)
	if has_node("AnimationPlayer"):
		anim = get_node("AnimationPlayer")
	if has_node("AudioStreamPlayer"):
		audio = get_node("AudioStreamPlayer")

func attach_devil():
	with_devil = true
	if anim:
		anim.play("devil_in")
	if audio:
		audio.play()

func shot() -> void:
	if is_in_group("bad"):
		game.hurt()
		var smoke = BAD_APPEAR.instantiate()
		smoke.global_position = global_position
		game.add_child(smoke)
		queue_free()
	if is_in_group("good"):
		if with_devil:
			if anim:
				anim.play("devil_out")
				@warning_ignore("confusable_local_declaration")
				var smoke = DEVIL_DIE.instantiate()
				smoke.global_position = global_position
				game.add_child(smoke)
			with_devil = false
			return
		var smoke = GOOD_COLLECT.instantiate()
		smoke.global_position = global_position
		game.add_child(smoke)
		if len(get_tree().get_nodes_in_group("good")) == 1:
			main.good_outcome = true
			music.speed_up()
		queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	if xform.origin.x > max_right:
		xform.origin.x = max_left
	if xform.origin.x < max_left:
		xform.origin.x = max_right
	if xform.origin.y > max_down:
		xform.origin.y = max_up
	if xform.origin.y < max_up:
		xform.origin.y = max_down
	state.transform = xform
