extends Area2D

var initialized = false
var follow: WeakRef
@export var speed := 100
@onready var anim = $Icon
var game: Game

const DEVIL_DIE = preload("res://balls/devil_die.tscn")

func _process(delta: float) -> void:
	if initialized:
		if follow.get_ref():
			var ref := follow.get_ref() as Node2D
			position += Vector2.RIGHT.rotated(get_angle_to(ref.position)) * speed * delta
			if position.distance_to(ref.position) < 180:
				anim.play("sneak")
			else:
				anim.play("walk")
			anim.flip_h = ref.position.x < position.x
			if position.distance_to(ref.position) < 100:
				ref.attach_devil()
				queue_free()
		else:
			var smoke = DEVIL_DIE.instantiate()
			smoke.global_position = global_position
			game.add_child(smoke)
			queue_free()

func shot() -> void:
	var smoke = DEVIL_DIE.instantiate()
	smoke.global_position = global_position
	game.add_child(smoke)
	queue_free()
