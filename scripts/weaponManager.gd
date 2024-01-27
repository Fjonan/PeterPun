extends Node2D

var muzzle_radius = 40

var aim_time_default: float = 1.0
var aim_time_target: float = aim_time_default
var aim_time: float = aim_time_default

@onready var current_weapon = $AK
@onready var timer: Timer = $TypingTimer

func start_slowdown():
	timer.stop()
	timer.wait_time = 1.0
	aim_time_target = 0.05
	timer.start()


func _on_typing_timer_timeout():
	aim_time_target = aim_time_default

var weapons = []

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "shoot"))
	weapons = get_children()

func _process(delta):
	updateWeapon()

func shoot():
	start_slowdown()
	GlobalSignals.emit_signal("camera_shake")
	GlobalSignals.emit_signal("bullet_fired", current_weapon.get_node("Muzzle").global_transform, current_weapon.global_transform.basis_xform(Vector2.RIGHT), current_weapon.damage)
	
func updateWeapon(): 
	aim_time = lerpf(aim_time, aim_time_target, 0.25)
	var aim_dir = Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down")) * muzzle_radius
	if aim_dir != Vector2.ZERO:
		current_weapon.rotation = lerp_angle(current_weapon.rotation, aim_dir.angle(), aim_time)

