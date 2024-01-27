extends Node2D

var muzzle_radius = 40
@onready var current_weapon = $AK

var weapons = []

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "shoot"))
	weapons = get_children()

func _process(delta):
	updateWeapon()

func shoot():
	GlobalSignals.emit_signal("camera_shake")
	GlobalSignals.emit_signal("bullet_fired", current_weapon.get_node("Muzzle").global_transform, current_weapon.global_transform.basis_xform(Vector2.RIGHT), current_weapon.damage)
	
func updateWeapon(): 
	var aim_dir = Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down")) * muzzle_radius
	if aim_dir != Vector2.ZERO:
		current_weapon.rotation = lerp_angle(current_weapon.rotation, aim_dir.angle(), 0.0025)
