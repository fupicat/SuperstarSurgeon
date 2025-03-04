class_name Game
extends CanvasLayer

@onready var music := %Music as Music
@onready var ui := %UI as UI
@onready var main := get_parent()
@onready var lose1 := $Lose1
@onready var lose2 := $Lose2
var lives = 3
var in_game = false

@export var levels: Array[PackedScene]

const GOOD = preload("res://balls/good.tscn")
const BAD = preload("res://balls/bad.tscn")

func _ready() -> void:
    add_child(levels[0].instantiate())
    music.transition_to_game.connect(func():
        in_game = true
        lives = 3
        ui.update_lives(lives)
        )
    music.transition_to_hospital.connect(func():
        in_game = false
        )
    music.spawn_level.connect(func(number):
        var current_level = get_tree().get_first_node_in_group("level")
        if current_level:
            current_level.remove_from_group("level")
            current_level.queue_free()
        if number >= len(levels):
            return
        var new_level = levels[number].instantiate()
        add_child(new_level)
        )
    music.game_start.connect(func():
        for good_spawner in get_tree().get_nodes_in_group("good_spawner"):
            var good = GOOD.instantiate()
            good.music = music
            good.game = self
            good.main = main
            good.global_position = good_spawner.global_position
            add_child(good)
            if "devil" in good_spawner:
                var weak = weakref(good_spawner.devil)
                if weak.get_ref():
                    good_spawner.devil.game = self
                    good_spawner.devil.follow = weakref(good)
                    good_spawner.devil.initialized = true
            good_spawner.queue_free()
        for bad_spawner in get_tree().get_nodes_in_group("bad_spawner"):
            var bad = BAD.instantiate()
            bad.music = music
            bad.game = self
            bad.main = main
            bad.global_position = bad_spawner.global_position
            add_child(bad)
            bad_spawner.queue_free()
        )

func hurt():
    lives -= 1
    ui.update_lives(lives)
    lose1.play()
    lose2.play()
    if lives <= 0:
        music.speed_up()
    
