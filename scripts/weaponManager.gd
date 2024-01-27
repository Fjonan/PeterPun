extends Node2D

var muzzle_radius = 40
@onready var current_weapon = $AK

var weapons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("shoot", Callable(self, "shoot"))
	weapons = get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateWeapon()

func shoot():
	GlobalSignals.emit_signal("camera_shake")
	var direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	GlobalSignals.emit_signal("bullet_fired", current_weapon.get_node("Muzzle").global_transform, position, direction)
	
func updateWeapon(): 
	var position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	var updated_rotation = current_weapon.position.direction_to(position).angle()
	current_weapon.rotation = updated_rotation
