extends AudioListener2D

var hitSound1 = preload("res://assets/audio/scream01.ogg")
var hitSound2 = preload("res://assets/audio/scream02.mp3")
var hitSound3 = preload("res://assets/audio/scream03.mp3")
var hitSound4 = preload("res://assets/audio/scream04.mp3")
var hitSounds = [hitSound1, hitSound2, hitSound3, hitSound4]
var hitSoundInstance = AudioStreamPlayer.new()

var shotSound = preload("res://assets/audio/shot01.ogg")
var shotSoundInstance = AudioStreamPlayer.new()

var deathBellAudio = preload("res://assets/audio/bell_of_death.mp3")
var deathBellAudioInstance = AudioStreamPlayer.new()

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "play_shot_sound"))
	GlobalSignals.connect("killed", Callable(self, "play_hit_sound"))
	GlobalSignals.connect("kill_all_item_colleced", Callable(self, "play_kill_all_sound"))
	
	add_child(shotSoundInstance)
	add_child(hitSoundInstance)
	add_child(deathBellAudioInstance)

func play_shot_sound():
	shotSoundInstance.stop()
	shotSoundInstance.stream = shotSound
	shotSoundInstance.play()
	
func play_hit_sound():
	hitSoundInstance.stop()
	var r = randi_range(0, 3)
	hitSoundInstance.stream = hitSounds[r]
	hitSoundInstance.play()

func play_kill_all_sound():
	deathBellAudioInstance.stop()
	deathBellAudioInstance.stream = deathBellAudio
	deathBellAudioInstance.play()
