extends Node2D

@export var Bullet: PackedScene

@onready var player = $Player

func _ready():
	GlobalSignals.connect("bullet_fired", Callable(self, "_on_bullet_fired"))

# Called when the node enters the scene tree for the first time.
func _on_bullet_fired(transform, position, direction, damage):
	print("Fired from manager")
	var bullet = Bullet.instantiate()
	add_child(bullet)
	bullet.transform = transform
	bullet.spawn_Bullet(position, direction, damage)
