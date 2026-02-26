# get_playback_position não funciona na web nessa versão!
# Então aqui estou tentando consertar.

extends AudioStreamPlayer

var time_begin: int
var last_tick: int
var scaled_time: float
var time_delay: float

func bs_play() -> void:
	time_begin = Time.get_ticks_usec()
	last_tick = time_begin
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	scaled_time = 0.0
	play()

func bs_get_playback_position() -> float:
	var now := Time.get_ticks_usec()
	var real_delta = (now - last_tick) / 1000000.0
	last_tick = now
	scaled_time += real_delta * pitch_scale
	# Compensate for latency.
	var returned_time = scaled_time - time_delay
	print(returned_time)
	return max(0, returned_time)
