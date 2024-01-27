extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.25
@export var cam: PhantomCamera2D = null

@onready var muzzle = $Weapon/Muzzle
@onready var weaponsprite = $Weapon/WeaponSprite

var player_state = "idle"
var muzzle_radius = 40

func _ready():
	GlobalSignals.connect("shoot", Callable(self, "shoot"))
	cam.append_follow_group_node($Weapon/Aimdot)


func _physics_process(delta):
	#updateMuzzle()
	updateWeapon()
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
	
func shoot():
	var direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	GlobalSignals.emit_signal("bullet_fired", muzzle.global_transform, position, direction)

func updateMuzzle():
	var direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	muzzle.position = position
	
func updateWeapon(): 
	var position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	var updated_rotation = $Weapon.position.direction_to(position).angle()
	$Weapon.rotation = updated_rotation

func player():
	pass
