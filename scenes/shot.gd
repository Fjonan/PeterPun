extends AudioListener2D


var shotSound = preload("res://assets/audio/shot01.ogg")
var shotSoundInstance = AudioStreamPlayer.new()

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "play_shot_sound"))
	add_child(shotSoundInstance)


func play_shot_sound():
	shotSoundInstance.stop()
	shotSoundInstance.stream = shotSound
	shotSoundInstance.play()
