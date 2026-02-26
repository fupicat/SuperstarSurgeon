extends Node2D

@onready var game: Game = %Game
@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sound1 = $Laser
@onready var sound2 = $Smoke

func _ready() -> void:
	line.clear_points()

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if not game.in_game:
		return
	if event is InputEventScreenTouch and event.is_pressed():
		look_at(get_global_mouse_position())
		ray.force_raycast_update()
		var collider := ray.get_collider()
		line.clear_points()
		line.add_point(Vector2.ZERO)
		line.add_point(Vector2.RIGHT * (
			line.global_position.distance_to(
				ray.get_collision_point()
			) if collider else 1000.0
		))
		anim.stop()
		anim.play("Shoot")
		sound1.play()
		sound2.play()
		
		if collider:
			(collider as Node).shot()
