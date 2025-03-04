class_name Music
extends Node

const MUS_START = preload("res://music/start.ogg")
const MUS_PHASES = [
    preload("res://music/phase1.ogg"),
    preload("res://music/phase1end.ogg"),
    preload("res://music/phase2.ogg"),
    preload("res://music/phase2end.ogg"),
    preload("res://music/phase3.ogg"),
    preload("res://music/phase3end.ogg"),
    preload("res://music/phase4.ogg"),
    preload("res://music/phase4end.ogg"),
    ]
const MUS_TRANSITION = preload("res://music/transition.ogg")
const MUS_END = preload("res://music/end.ogg")

## Beats per minute
@export var bpm := 110.0
## Seconds per beat
var spb := 60/bpm
## Current beat
var beat := 1

@onready var _player := $AudioStreamPlayer as AudioStreamPlayer
var song_progress := 0.0

@onready var _music_sections: AnimationPlayer = %MusicSections
@onready var _vocals: AudioStreamPlayer = %Vocals

var fast_forward = false
var fast_forward_cutscene = false

signal beat_passed(beat)
signal transition_to_game
signal transition_to_hospital
signal end
signal hospital_cutscene(number)
signal game_start
signal spawn_level(number)
signal speeding_up
signal speeding_up_cutscene

func _ready() -> void:
    fast_forward = false
    _player.pitch_scale = 1
    _vocals.volume_db = 0
    _music_sections.speed_scale = 1
    _player.stream = MUS_START
    _player.play()
    _player.finished.connect(func(): play_phase(0), CONNECT_ONE_SHOT)
    beat = 1
    beat_passed.emit(beat)
    await get_tree().create_timer(1).timeout
    transition_to_game.emit()

func speed_up():
    fast_forward = true
    speeding_up.emit()

func speed_up_cutscene():
    fast_forward = true
    _vocals.volume_db = -80
    fast_forward_cutscene = true

func _process(_delta: float) -> void:
    var playback_position: float = _player.get_playback_position()
    var stream: AudioStream = _player.stream
    song_progress = remap(playback_position, 0, stream.get_length(), 0, 1)
    if playback_position >= beat * spb:
        beat += 1
        beat_passed.emit(beat)
    if fast_forward:
        var speed_up_amount = lerp(_player.pitch_scale, 30.0, 0.01)
        _player.pitch_scale = speed_up_amount
        if fast_forward_cutscene:
            _music_sections.speed_scale = speed_up_amount

func play_phase(phase: int):
    if phase % 2 != 0:
        hospital_cutscene.emit(floor(phase / 2))
    else:
        game_start.emit()
    fast_forward = false
    _player.pitch_scale = 1
    _vocals.volume_db = 0
    _music_sections.speed_scale = 1
    _player.stream = MUS_PHASES[phase]
    _player.play()
    beat = 1
    beat_passed.emit(beat)
    await _player.finished
    if (len(MUS_PHASES) > phase + 1):
        if phase % 2 == 0:
            transition_to_hospital.emit()
        else:
            transition_to_game.emit()
        fast_forward = false
        _player.pitch_scale = 1
        _vocals.volume_db = 0
        _music_sections.speed_scale = 1
        _player.stream = MUS_TRANSITION
        _player.play()
        await _player.finished
        if phase % 2 == 0:
            spawn_level.emit(ceil((phase + 1) / 2) + 1)
        play_phase(phase + 1)
    else:
        fast_forward = false
        _player.pitch_scale = 1
        _vocals.volume_db = 0
        _music_sections.speed_scale = 1
        _player.stream = MUS_END
        _player.play()
        await _player.finished
        end.emit()
        
