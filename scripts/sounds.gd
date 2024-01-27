extends AudioListener2D

var hitSound = preload("res://assets/audio/scream01.ogg")
var hitSoundInstance = AudioStreamPlayer.new()

var shotSound = preload("res://assets/audio/shot01.ogg")
var shotSoundInstance = AudioStreamPlayer.new()

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "play_shot_sound"))
	GlobalSignals.connect("hit", Callable(self, "play_hit_sound"))
	add_child(shotSoundInstance)
	add_child(hitSoundInstance)

func play_shot_sound():
	shotSoundInstance.stop()
	shotSoundInstance.stream = shotSound
	shotSoundInstance.play()
	
func play_hit_sound():
	print('hit sound')
	hitSoundInstance.stop()
	hitSoundInstance.stream = hitSound
	hitSoundInstance.play()


