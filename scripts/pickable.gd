extends Area2D
class_name Pickable

@export var type: String = ''

func _ready():
	connect("body_entered", Callable(self, "_on_Pickable_body_entered"))
	if (type == ''):
		print('NO TYPE FOR PICKUP SET')
		return


func _on_Pickable_body_entered(body):
	if body is Player:
		GlobalSignals.emit_signal("player_got_pickable", type)
		queue_free()

