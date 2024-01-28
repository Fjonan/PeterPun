extends PointLight2D

func _on_light_timer_timeout():
	print('Light changed')
	if (energy == 1):
		energy = 0.5
	else:
		energy = 1

