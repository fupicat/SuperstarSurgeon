extends TextureButton

@export var language: String

func _ready() -> void:
	pressed.connect(func():
		TranslationServer.set_locale(language)
		$AudioStreamPlayer.play()
	)
