extends Area2D
class_name Pickable

@onready var timer = $Cooldown
var c_player = null

func _ready():
	connect("body_entered", Callable(self, "_on_Pickable_body_entered"))

func _on_Pickable_body_entered(body):
	if body is Player:
		c_player = body
		start_boost()
		queue_free()

func start_boost():
	c_player.speed = 600
	await get_tree().create_timer(2.0).timeout
	c_player.speed = 200

