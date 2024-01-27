extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.25

var player_state = "idle"
var muzzle_radius = 40

func _physics_process(delta):
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
		shoot()
	
func play_animation(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle_old")
		
	if player_state == "moving":
		if dir.x == 1:
			print('right')
			$AnimatedSprite2D.play("right_old")
		if dir.x == -1:
			print('left')
			$AnimatedSprite2D.play("left_old")
		if dir.y == 1:
			$AnimatedSprite2D.play("idle_old")
		if dir.y == -1:
			$AnimatedSprite2D.play("idle_old")

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
	GlobalSignals.emit_signal("bullet_fired", position, direction)
	

func _process(delta):
	# $AimNode.position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	# $Muzzle.position = Vector2(Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"), Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")).normalized() * muzzle_radius
	pass

func player():
	pass
