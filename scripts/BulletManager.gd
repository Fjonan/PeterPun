extends Node2D

@export var Bullet: PackedScene

@onready var player = $Player

func _ready():
	GlobalSignals.connect("bullet_fired", Callable(self, "_on_bullet_fired"))

# Called when the node enters the scene tree for the first time.
func _on_bullet_fired(position, direction):
	print("Fired from manager")
	var bullet = Bullet.instantiate()
	add_child(bullet)
	bullet.transform = player.get_node("Muzzle").global_transform
	bullet.set_direction(position, direction)
