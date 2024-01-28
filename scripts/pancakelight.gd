extends PointLight2D

var maxEnergy = 1.5
var minEnergy = 0.5

func _on_light_timer_timeout():
	if (energy == maxEnergy): energy = minEnergy
	else: energy = maxEnergy

