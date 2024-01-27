extends CharacterBody2D
class_name Player

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.25
@export var cam: PhantomCamera2D = null

@onready var weaponmanager = $WeaponManager

var player_state = "idle"
var muzzle_radius = 40

var controlls_locked = true

func _ready():
	cam.append_follow_group_node(weaponmanager.current_weapon.get_node("Aimdot"))
	GlobalSignals.connect("game_over", Callable(self, "lock_controlls"))
	GlobalSignals.connect("game_started", Callable(self, "lock_controlls"))
	
func _physics_process(delta):
	
	if (controlls_locked): return
	
	var direction = get_input()
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		player_state = "moving"
	else:
		player_state = "idle"
		velocity = velocity.lerp(Vector2.ZERO, friction)
		

	play_animation(direction)
	move_and_slide()

	for i in get_slide_collision_count():
		var enemey = get_slide_collision(i).get_collider() as Enemy
		if enemey != null:
			GlobalSignals.emit_signal("game_over")
			break
	
	if Input.is_action_just_pressed("shoot"):
		GlobalSignals.emit_signal("shoot")
	
func play_animation(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
		
	if player_state == "moving":
		if dir.x == 1:
			$AnimatedSprite2D.play("right")
		if dir.x == -1:
			$AnimatedSprite2D.play("left")
		if dir.y == 1:
			$AnimatedSprite2D.play("idle")
		if dir.y == -1:
			$AnimatedSprite2D.play("idle")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	return input

func lock_controlls(): 
	controlls_locked = !controlls_locked
	
