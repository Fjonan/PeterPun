extends CharacterBody2D
class_name Player

@export var speed = 200
var speed_default = speed
@export var friction = 0.5
@export var acceleration = 0.25
@export var cam: PhantomCamera2D = null

@onready var weaponmanager = $WeaponManager

var player_state = "idle"
var muzzle_radius = 0
var controlls_locked = true
var hasActiveItem = false

func _ready():
	cam.append_follow_group_node(weaponmanager.current_weapon.get_node("Aimdot"))
	GlobalSignals.connect("game_over", Callable(self, "lock_controlls"))
	GlobalSignals.connect("game_started", Callable(self, "lock_controlls"))
	GlobalSignals.connect("camera_shake", Callable(self, "start_slowdown")) 
	GlobalSignals.connect("player_got_pickable", Callable(self, "handle_pickable"))
	
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
	
	if Input.is_action_just_pressed("shoot"):
		if (owner.owner.singlePlayer):
			GlobalSignals.emit_signal("shoot")

	for i in get_slide_collision_count():
		var enemey = get_slide_collision(i).get_collider() as Enemy
		if enemey != null:
			GlobalSignals.emit_signal("game_over")
			break
	
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
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func lock_controlls(): 
	controlls_locked = !controlls_locked
	
func handle_pickable(type): 
	print('Player picked up item: ', type)
	hasActiveItem = true
	
	match type: 
		'speed':
			print('speed start')
			speed = 450
			await get_tree().create_timer(5).timeout
			speed = speed_default
			print('speed end')
	
	hasActiveItem = false

func start_slowdown():
	if (hasActiveItem): return
	speed = 100
	print("slow player")

func _on_typing_timer_timeout():
	if (hasActiveItem): return
	print("fast player")
	speed = speed_default


func _on_item_cooldown_timeout():
	pass # Replace with function body.
