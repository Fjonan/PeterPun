extends Area2D

@export var speed = 750
var direction := Vector2.ZERO


func _physics_process(delta: float):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity
	
func _on_Bullet_body_entered(body):
	queue_free()
	
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
