extends CanvasLayer

@onready var music = %Music
@onready var doctor_anim = $Doctor/AnimationPlayer

func _ready() -> void:
    music.connect("beat_passed", _on_music_beat_passed)

func _on_music_beat_passed(beat: int):
    doctor_anim.play("beat")
