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
		if (type == 'puncake'):
			GlobalSignals.emit_signal("kill_all_item_colleced")
			queue_free()
			return
			
		GlobalSignals.emit_signal("player_got_pickable", type)
		queue_free()

