extends Area2D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		(body as RigidBody2D).apply_impulse(Vector2(1300, 0).rotated(get_angle_to(body.position)))
		anim.stop()
		anim.play("Bump")
