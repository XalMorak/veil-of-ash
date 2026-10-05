extends Node
## Procedural SFX and a looping ember bed. No imported assets required.

var music: AudioStreamPlayer
var _cache: Dictionary = {}

func _ready() -> void:
	_bus("Master")
	_bus("Music", "Master")
	_bus("SFX", "Master")
	music = AudioStreamPlayer.new()
	music.bus = "Music"
	music.volume_db = -10.0
	add_child(music)
	music.stream = _bed()
	music.finished.connect(func() -> void: music.play())
	music.play()

func _bus(name: String, parent := "") -> void:
	if AudioServer.get_bus_index(name) >= 0:
		return
	AudioServer.add_bus()
	var idx := AudioServer.bus_count - 1
	AudioServer.set_bus_name(idx, name)
	if parent != "":
		AudioServer.set_bus_send(idx, parent)

func play(name: String, db: float = 0.0) -> void:
	var stream: AudioStreamWAV = _cache.get(name)
	if stream == null:
		stream = _cue(name)
		_cache[name] = stream
	var p := AudioStreamPlayer.new()
	p.bus = "SFX"
	p.stream = stream
	p.volume_db = db
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()

func set_master(linear: float) -> void:
	_vol("Master", linear)

func set_music(linear: float) -> void:
	_vol("Music", linear)

func set_sfx(linear: float) -> void:
	_vol("SFX", linear)

func _vol(bus: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus)
	if idx < 0:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(linear, 0.001, 1.0)))

func _cue(name: String) -> AudioStreamWAV:
	match name:
		"swing":
			return _tone(220.0, 0.16, 0.4, 80.0)
		"hit":
			return _noise(0.18, 0.45)
		"hurt":
			return _tone(140.0, 0.26, 0.45, -40.0)
		"rest":
			return _tone(330.0, 0.55, 0.3, 20.0)
		"death":
			return _tone(70.0, 0.8, 0.5, -30.0)
		_:
			return _tone(520.0, 0.1, 0.28, 0.0)

func _tone(freq: float, dur: float, amp: float, sweep: float) -> AudioStreamWAV:
	var rate := 22050
	var n := int(rate * dur)
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t := float(i) / float(rate)
		var e := 1.0 - t / dur
		var f := freq + sweep * t
		var s := sin(TAU * f * t) * amp * e
		data.encode_s16(i * 2, int(clampf(s, -1.0, 1.0) * 32767.0))
	return _wav(data, rate)

func _noise(dur: float, amp: float) -> AudioStreamWAV:
	var rate := 22050
	var n := int(rate * dur)
	var data := PackedByteArray()
	data.resize(n * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in n:
		var e := 1.0 - float(i) / float(n)
		var s := rng.randf_range(-1.0, 1.0) * amp * e
		data.encode_s16(i * 2, int(s * 32767.0))
	return _wav(data, rate)

func _bed() -> AudioStreamWAV:
	var rate := 22050
	var n := rate * 8
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t := float(i) / float(rate)
		var s := sin(TAU * 55.0 * t) * 0.18 + sin(TAU * 82.5 * t) * 0.08
		data.encode_s16(i * 2, int(s * 32767.0))
	return _wav(data, rate)

func _wav(data: PackedByteArray, rate: int) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.stereo = false
	stream.data = data
	return stream
