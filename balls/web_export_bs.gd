# Por algum motivo no export pra web ele acha que o sinal "animation_finished" tem 1 parâmetro
# então dá um erro quando eu conecto em queue_free, mesmo obviamente as duas funções tendo
# 0 parâmetros. idfk

extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(func():
		get_parent().queue_free()
	)
