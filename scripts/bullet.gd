extends Area2D

@export var speed = 8

var direction = Vector2.ZERO
func _physics_process(delta: float):
	position += direction * speed * delta

	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity
	
func set_direction(origin: Vector2, direction: Vector2):
	if (direction.x == 0 && direction.y == 0):
		direction = Vector2(-1,0)
		
	self.direction = (origin - direction).normalized()
	$Sprite2D.rotation_degrees = rad_to_deg(direction.angle())

